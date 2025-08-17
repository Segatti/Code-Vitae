class BackgroundJob {
  final String id;
  final int priority;
  final Future<dynamic> Function() task;
  final void Function(dynamic data)? onSuccess;
  final void Function(Object error)? onError;

  BackgroundJob({
    required this.id,
    required this.task,
    this.priority = 0,
    this.onSuccess,
    this.onError,
  });
}
