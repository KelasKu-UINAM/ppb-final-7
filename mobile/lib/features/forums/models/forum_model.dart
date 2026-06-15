import 'package:flutter/foundation.dart';

@immutable
class ForumModel {
  final int id;
  final int classId;
  final int? subjectId;
  final String type; // 'class' | 'subject'
  final String name;
  final String? subjectName; // from LEFT JOIN subjects s
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ForumModel({
    required this.id,
    required this.classId,
    this.subjectId,
    required this.type,
    required this.name,
    this.subjectName,
    this.createdAt,
    this.updatedAt,
  });

  bool get isClass => type == 'class';
  bool get isSubject => type == 'subject';

  String get typeLabel => isSubject ? 'Mata Kuliah' : 'Forum Kelas';

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      id: (json['id'] as num).toInt(),
      classId: (json['class_id'] as num).toInt(),
      subjectId: json['subject_id'] != null
          ? (json['subject_id'] as num).toInt()
          : null,
      type: json['type'] as String? ?? 'class',
      name: json['name'] as String? ?? '',
      subjectName: json['subject_name'] as String?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ForumModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
