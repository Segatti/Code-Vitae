import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message_insert_event.dart';
import '../models/notification_insert_event.dart';

class SupabaseRealtimeService {
  final SupabaseClient _client;

  StreamController<void>? _inboxEvents;
  int _inboxListenerCount = 0;
  RealtimeChannel? _chatInboxChannel;
  String? _inboxUserId;

  StreamController<ChatMessageInsertEvent>? _incomingChatMessageEvents;
  int _incomingChatMessageListenerCount = 0;

  final Map<String, StreamController<void>> _messageEvents = {};
  final Map<String, int> _messageListenerCounts = {};
  final Map<String, RealtimeChannel> _messageChannels = {};
  final Map<String, ({String chatId, String table})> _messageChannelParams = {};

  SupabaseRealtimeService(this._client);

  Future<void> resumeFromBackground() async {
    if (_inboxListenerCount > 0 || _incomingChatMessageListenerCount > 0) {
      await _resetChatInboxChannel();
      if (_inboxListenerCount > 0) {
        _ensureChatInboxChannel();
      }
    }

    final keys = _messageListenerCounts.keys.toList();
    for (final channelKey in keys) {
      if ((_messageListenerCounts[channelKey] ?? 0) <= 0) continue;
      final params = _messageChannelParams[channelKey];
      if (params == null) continue;
      await _resetMessageChannel(channelKey);
      _ensureMessageChannel(
        channelKey: channelKey,
        chatId: params.chatId,
        table: params.table,
      );
    }
  }

  Stream<void> watchChatInboxChanges() {
    _inboxEvents ??= StreamController<void>.broadcast(
      onListen: () {
        _inboxListenerCount++;
        _ensureChatInboxChannel();
      },
      onCancel: () {
        _inboxListenerCount--;
        if (_inboxListenerCount <= 0) {
          _inboxListenerCount = 0;
          _teardownChatInboxChannel();
        }
      },
    );
    return _inboxEvents!.stream;
  }

  Stream<ChatMessageInsertEvent> watchIncomingChatMessages(String userId) {
    _inboxUserId = userId;
    _incomingChatMessageEvents ??= StreamController<ChatMessageInsertEvent>.broadcast(
      onListen: () {
        _incomingChatMessageListenerCount++;
        _ensureChatInboxChannel();
      },
      onCancel: () {
        _incomingChatMessageListenerCount--;
        if (_incomingChatMessageListenerCount <= 0) {
          _incomingChatMessageListenerCount = 0;
          if (_inboxListenerCount <= 0) {
            unawaited(_resetChatInboxChannel());
          }
        }
      },
    );
    return _incomingChatMessageEvents!.stream;
  }

  Stream<void> watchChatMessages({
    required String chatId,
    required bool personPeerChat,
  }) {
    final table =
        personPeerChat ? 'person_peer_messages' : 'messages';
    final channelKey = '$table:$chatId';

    _messageEvents[channelKey] ??= StreamController<void>.broadcast(
      onListen: () {
        final count = (_messageListenerCounts[channelKey] ?? 0) + 1;
        _messageListenerCounts[channelKey] = count;
        _ensureMessageChannel(
          channelKey: channelKey,
          chatId: chatId,
          table: table,
        );
      },
      onCancel: () {
        final count = (_messageListenerCounts[channelKey] ?? 1) - 1;
        if (count <= 0) {
          _messageListenerCounts.remove(channelKey);
          _teardownMessageChannel(channelKey);
        } else {
          _messageListenerCounts[channelKey] = count;
        }
      },
    );
    return _messageEvents[channelKey]!.stream;
  }

  void _emitInboxChange() {
    final controller = _inboxEvents;
    if (controller != null && !controller.isClosed) {
      controller.add(null);
    }
  }

  void _emitIncomingChatMessage(ChatMessageInsertEvent event) {
    final controller = _incomingChatMessageEvents;
    if (controller != null && !controller.isClosed) {
      controller.add(event);
    }
  }

  void _onChatMessageInsert(
    PostgresChangePayload payload, {
    required bool isPersonPeerChat,
  }) {
    _emitInboxChange();
    if (payload.eventType != PostgresChangeEvent.insert) return;

    final userId = _inboxUserId ?? _client.auth.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    final record = payload.newRecord;
    final senderId = record['sender_id']?.toString() ?? '';
    if (senderId.isEmpty || senderId == userId) return;

    final chatId = record['chat_id']?.toString() ?? '';
    if (chatId.isEmpty) return;

    _emitIncomingChatMessage(
      ChatMessageInsertEvent(
        chatId: chatId,
        senderId: senderId,
        preview: record['content']?.toString() ?? '',
        isPersonPeerChat: isPersonPeerChat,
      ),
    );
  }

  void _emitMessageChange(String channelKey) {
    final controller = _messageEvents[channelKey];
    if (controller != null && !controller.isClosed) {
      controller.add(null);
    }
  }

  void _ensureChatInboxChannel() {
    if (_chatInboxChannel != null) return;

    final userId =
        _inboxUserId ?? _client.auth.currentUser?.id ?? 'anon';
    _inboxUserId ??= userId == 'anon' ? null : userId;
    final channel = _client.channel('chat-inbox-$userId');

    void emitMeta(PostgresChangePayload payload) => _emitInboxChange();

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chats',
          callback: emitMeta,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'person_peer_chats',
          callback: emitMeta,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          callback: (payload) =>
              _onChatMessageInsert(payload, isPersonPeerChat: false),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'person_peer_messages',
          callback: (payload) =>
              _onChatMessageInsert(payload, isPersonPeerChat: true),
        );

    channel.subscribe((status, error) {
      if (error != null) {
        debugPrint('chat-inbox realtime error: $error');
      }
      if (status == RealtimeSubscribeStatus.subscribed) {
        debugPrint('chat-inbox realtime subscribed');
      }
    });

    _chatInboxChannel = channel;
  }

  Future<void> _resetChatInboxChannel() async {
    final channel = _chatInboxChannel;
    _chatInboxChannel = null;
    if (channel != null) {
      await _client.removeChannel(channel);
    }
  }

  void _teardownChatInboxChannel() {
    unawaited(_resetChatInboxChannel());
  }

  void _ensureMessageChannel({
    required String channelKey,
    required String chatId,
    required String table,
  }) {
    if (_messageChannels.containsKey(channelKey)) return;

    _messageChannelParams[channelKey] = (chatId: chatId, table: table);

    final channel = _client.channel('chat-msgs-$channelKey');

    void emit(PostgresChangePayload _) =>
        _emitMessageChange(channelKey);

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: emit,
        )
        .subscribe((status, error) {
          if (error != null) {
            debugPrint('chat-msgs $channelKey realtime error: $error');
          }
          if (status == RealtimeSubscribeStatus.subscribed) {
            debugPrint('chat-msgs $channelKey subscribed');
          }
        });

    _messageChannels[channelKey] = channel;
  }

  Future<void> _resetMessageChannel(String channelKey) async {
    final channel = _messageChannels.remove(channelKey);
    if (channel != null) {
      await _client.removeChannel(channel);
    }
  }

  void _teardownMessageChannel(String channelKey) {
    unawaited(_resetMessageChannel(channelKey));
    _messageChannelParams.remove(channelKey);
    final events = _messageEvents.remove(channelKey);
    if (events != null && !events.isClosed) {
      unawaited(events.close());
    }
  }

  Stream<void> watchUserNotifications(String accountId) {
    RealtimeChannel? notificationsChannel;

    late final StreamController<void> controller;
    controller = StreamController<void>.broadcast(
      onListen: () async {
        notificationsChannel ??=
            _client.channel('notifications-$accountId');
        final channel = notificationsChannel!;
        void emit(PostgresChangePayload _) {
          if (!controller.isClosed) controller.add(null);
        }

        channel
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'user_notifications',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'account_id',
                value: accountId,
              ),
              callback: emit,
            )
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'user_notifications',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'account_id',
                value: accountId,
              ),
              callback: emit,
            );
        channel.subscribe();
      },
      onCancel: () async {
        final channel = notificationsChannel;
        notificationsChannel = null;
        if (channel != null) {
          await _client.removeChannel(channel);
        }
      },
    );
    return controller.stream;
  }

  Stream<NotificationInsertEvent> watchUserNotificationInserts(
    String accountId,
  ) {
    RealtimeChannel? notificationsChannel;

    late final StreamController<NotificationInsertEvent> controller;
    controller = StreamController<NotificationInsertEvent>.broadcast(
      onListen: () async {
        notificationsChannel ??=
            _client.channel('notifications-insert-$accountId');
        final channel = notificationsChannel!;

        channel
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'user_notifications',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'account_id',
                value: accountId,
              ),
              callback: (payload) {
                if (controller.isClosed) return;
                final record = payload.newRecord;
                controller.add(
                  NotificationInsertEvent(
                    notificationType:
                        record['notification_type']?.toString() ?? '',
                    title: record['title']?.toString() ?? '',
                    body: record['body']?.toString() ?? '',
                    referenceId: record['reference_id']?.toString(),
                  ),
                );
              },
            )
            .subscribe();
      },
      onCancel: () async {
        final channel = notificationsChannel;
        notificationsChannel = null;
        if (channel != null) {
          await _client.removeChannel(channel);
        }
      },
    );
    return controller.stream;
  }
}
