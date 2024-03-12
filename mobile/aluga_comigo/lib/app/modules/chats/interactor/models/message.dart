import 'dart:convert';

import '../enums/message_type.dart';

class Message {
  final bool? isFromUser;
  final DateTime? dateTime;
  final String? value;
  final MessageType? type;

  const Message({
    this.isFromUser,
    this.dateTime,
    this.value,
    this.type,
  });

  Message copyWith({
    bool? isFromUser,
    DateTime? dateTime,
    String? value,
    MessageType? type,
  }) {
    return Message(
      isFromUser: isFromUser ?? this.isFromUser,
      dateTime: dateTime ?? this.dateTime,
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isFromUser': isFromUser,
      'dateTime': dateTime?.toIso8601String(),
      'value': value,
      'type': type?.name,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      isFromUser: map['isFromUser'] as bool,
      dateTime: map['dateTime'] != null
          ? DateTime.parse(map['dateTime'] as String)
          : null,
      value: map['value'] != null ? map['value'] as String : null,
      type: MessageType.getType(map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(isFromUser: $isFromUser, dateTime: $dateTime, value: $value, type: $type)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.isFromUser == isFromUser &&
        other.dateTime == dateTime &&
        other.value == value &&
        other.type == type;
  }

  @override
  int get hashCode {
    return isFromUser.hashCode ^
        dateTime.hashCode ^
        value.hashCode ^
        type.hashCode;
  }
}
