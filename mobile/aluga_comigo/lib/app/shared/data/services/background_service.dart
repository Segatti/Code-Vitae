import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import '../../domain/entities/background_job.dart';

class BackgroundProcessor {
  BackgroundProcessor._internal();

  static final BackgroundProcessor _instance = BackgroundProcessor._internal();

  factory BackgroundProcessor() => _instance;

  static final ListQueue<BackgroundJob> _queue = ListQueue();
  static bool _isProcessing = false;
  static Isolate? _isolate;
  static ReceivePort? _receivePort;
  static SendPort? _sendPort;

  static void addJob(BackgroundJob job) {
    _queue.add(job);
    _processQueue();
  }

  static void _processQueue() {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;
    _executeNext();
  }

  /// Inicializa o processamento em background usando Isolate
  static Future<void> _initializeBackgroundProcessing() async {
    if (_isolate != null) return;

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_backgroundWorker, _receivePort!.sendPort);

    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        final jobId = message['jobId'] as String;
        final result = message['result'];
        final error = message['error'];

        // Encontrar o job correspondente e executar callbacks
        final job = _queue.firstWhere(
          (job) => job.id == jobId,
          orElse: () => throw Exception('Job não encontrado'),
        );

        if (error != null) {
          job.onError?.call(error);
        } else {
          job.onSuccess?.call(result);
        }
      }
    });
  }

  /// Worker function que roda em um Isolate separado
  static void _backgroundWorker(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        final jobId = message['jobId'] as String;
        final task = message['task'] as Function;

        try {
          final result = await task();
          sendPort.send({'jobId': jobId, 'result': result});
        } catch (error) {
          sendPort.send({'jobId': jobId, 'error': error});
        }
      }
    });
  }

  static void _executeNext() async {
    await _initializeBackgroundProcessing();

    while (_queue.isNotEmpty) {
      // Sort by priority before execution
      final sortedJobs = _queue.toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
      _queue
        ..clear()
        ..addAll(sortedJobs);

      final job = _queue.removeFirst();

      // Enviar job para o Isolate
      _sendPort?.send({'jobId': job.id, 'task': job.task});
    }

    _isProcessing = false;
  }

  /// Método para processar jobs em background usando compute
  static Future<T> processInBackground<T>(
    Future<T> Function() task, {
    String? jobId,
  }) async {
    return await _computeWrapper(
      task,
      jobId ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  static Future<T> _computeWrapper<T>(
    Future<T> Function() task,
    String jobId,
  ) async {
    try {
      final result = await task();
      return result;
    } catch (error) {
      rethrow;
    }
  }

  /// Método para processar jobs em background usando Isolate
  static Future<T> processInIsolate<T>(
    Future<T> Function() task, {
    String? jobId,
  }) async {
    await _initializeBackgroundProcessing();

    final completer = Completer<T>();
    final currentJobId =
        jobId ?? DateTime.now().millisecondsSinceEpoch.toString();

    // Listener temporário para este job específico
    StreamSubscription? subscription;
    subscription = _receivePort!.listen((message) {
      if (message is Map<String, dynamic> && message['jobId'] == currentJobId) {
        subscription?.cancel();
        if (message['error'] != null) {
          completer.completeError(message['error']);
        } else {
          completer.complete(message['result'] as T);
        }
      }
    });

    _sendPort?.send({'jobId': currentJobId, 'task': task});

    return completer.future;
  }

  /// Limpa recursos quando não necessário
  static void dispose() {
    _isolate?.kill();
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
    _sendPort = null;
    _queue.clear();
    _isProcessing = false;
  }

  static List<String> getPendingJobIds() => _queue.map((e) => e.id).toList();

  /// Verifica se há jobs pendentes
  static bool get hasPendingJobs => _queue.isNotEmpty;

  /// Retorna o número de jobs pendentes
  static int get pendingJobsCount => _queue.length;
}
