import 'package:flutter/foundation.dart';

@immutable
class TaskModel {
  final int id;
  final int subjectId;
  final String subjectName;
  final String? subjectCode;
  final String title;
  final String? description;
  final DateTime deadline;
  final String? attachmentUrl;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    this.subjectCode,
    required this.title,
    this.description,
    required this.deadline,
    this.attachmentUrl,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['id'] as num).toInt(),
      subjectId: (json['subject_id'] as num).toInt(),
      subjectName: json['subject_name'] as String? ?? '',
      subjectCode: json['subject_code'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      attachmentUrl: json['attachment_url'] as String?,
      createdBy: json['created_by'] != null
          ? (json['created_by'] as num).toInt()
          : null,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  static const _months = [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  String get formattedDeadlineShort =>
      '${deadline.day} ${_months[deadline.month]} ${deadline.year}';

  String get formattedDeadlineFull {
    final h = deadline.hour.toString().padLeft(2, '0');
    final m = deadline.minute.toString().padLeft(2, '0');
    return '${deadline.day} ${_months[deadline.month]} ${deadline.year}, $h:$m';
  }

  // Lewat: deadline sudah lewat
  // Mendekat: ≤ 3 hari ke depan
  // Aman: > 3 hari lagi
  String get deadlineStatus {
    final now = DateTime.now();
    if (deadline.isBefore(now)) return 'Lewat';
    if (deadline.difference(now).inDays <= 3) return 'Mendekat';
    return 'Aman';
  }

  TaskModel copyWith({
    int? id,
    int? subjectId,
    String? subjectName,
    String? subjectCode,
    String? title,
    String? description,
    DateTime? deadline,
    String? attachmentUrl,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
