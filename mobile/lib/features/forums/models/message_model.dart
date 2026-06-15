import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final int id;
  final int forumId;
  final int? senderId;
  final String message;
  final String? senderName; // from JOIN users u
  final DateTime? createdAt;

  const MessageModel({
    required this.id,
    required this.forumId,
    this.senderId,
    required this.message,
    this.senderName,
    this.createdAt,
  });

  String get senderInitial {
    final n = (senderName ?? '').trim();
    return n.isEmpty ? '?' : n[0].toUpperCase();
  }

  String get formattedTime {
    if (createdAt == null) return '';
    final h = createdAt!.hour.toString().padLeft(2, '0');
    final m = createdAt!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] as num).toInt(),
      forumId: (json['forum_id'] as num).toInt(),
      senderId: json['sender_id'] != null
          ? (json['sender_id'] as num).toInt()
          : null,
      message: json['message'] as String? ?? '',
      senderName: json['sender_name'] as String?,
      createdAt: _parseDate(json['created_at']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MessageModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
