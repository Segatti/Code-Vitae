import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRealtimeService {
  final SupabaseClient _client;

  StreamController<void>? _inboxEvents;
  int _inboxListenerCount = 0;
  RealtimeChannel? _chatInboxChannel;

  final Map<String, StreamController<void>> _messageEvents = {};
  final Map<String, int> _messageListenerCounts = {};
  final Map<String, RealtimeChannel> _messageChannels = {};

  SupabaseRealtimeService(this._client);

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

  void _emitMessageChange(String channelKey) {
    final controller = _messageEvents[channelKey];
    if (controller != null && !controller.isClosed) {
      controller.add(null);
    }
  }

  void _ensureChatInboxChannel() {
    if (_chatInboxChannel != null) return;

    final userId = _client.auth.currentUser?.id ?? 'anon';
    final channel = _client.channel('chat-inbox-$userId');

    void emit(PostgresChangePayload _) => _emitInboxChange();

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chats',
          callback: emit,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'person_peer_chats',
          callback: emit,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          callback: emit,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'person_peer_messages',
          callback: emit,
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

  void _teardownChatInboxChannel() {
    final channel = _chatInboxChannel;
    _chatInboxChannel = null;
    if (channel != null) {
      unawaited(_client.removeChannel(channel));
    }
  }

  void _ensureMessageChannel({
    required String channelKey,
    required String chatId,
    required String table,
  }) {
    if (_messageChannels.containsKey(channelKey)) return;

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

  void _teardownMessageChannel(String channelKey) {
    final channel = _messageChannels.remove(channelKey);
    if (channel != null) {
      unawaited(_client.removeChannel(channel));
    }
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
}
