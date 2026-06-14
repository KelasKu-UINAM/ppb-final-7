import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';

@immutable
class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier(this._classId) : super(const TaskState());

  final int _classId;
  bool _loaded = false;

  Future<void> fetchTasks({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) return;
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 400));

    // Dummy hanya tersedia untuk kelas id=1; kelas lain tampil kosong.
    if (_classId != 1) {
      state = state.copyWith(tasks: const [], isLoading: false);
      _loaded = true;
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime dl(int daysFromNow) {
      final base = daysFromNow >= 0
          ? today.add(Duration(days: daysFromNow))
          : today.subtract(Duration(days: -daysFromNow));
      return DateTime(base.year, base.month, base.day, 23, 59);
    }

    final dummy = [
      TaskModel(
        id: 1,
        subjectId: 3,
        subjectName: 'Statistika',
        subjectCode: 'MTK-403',
        title: 'Tugas Analisis Data Deskriptif',
        description:
            'Hitung mean, median, modus, dan standar deviasi dari dataset yang disediakan. Kumpulkan dalam format PDF melalui portal kelas.',
        deadline: dl(-3),
        attachmentUrl: null,
        createdBy: 1,
      ),
      TaskModel(
        id: 2,
        subjectId: 2,
        subjectName: 'Aljabar Linear',
        subjectCode: 'MTK-402',
        title: 'Quiz Bab 4: Transformasi Linear',
        description:
            'Quiz online melalui portal Siakad. Materi: kernel, image, rank, nullity. Durasi 45 menit, hanya satu kali percobaan.',
        deadline: dl(2),
        attachmentUrl: 'https://siakad.uin-alauddin.ac.id/quiz/alj-402',
        createdBy: 1,
      ),
      TaskModel(
        id: 3,
        subjectId: 4,
        subjectName: 'Pemrograman Komputer',
        subjectCode: 'MTK-404',
        title: 'Laporan Praktikum Modul 5',
        description:
            'Buat laporan praktikum tentang struktur data array dan linked list. Format: docx, minimal 5 halaman.',
        deadline: dl(3),
        attachmentUrl: null,
        createdBy: 1,
      ),
      TaskModel(
        id: 4,
        subjectId: 1,
        subjectName: 'Analisis Real',
        subjectCode: 'MTK-401',
        title: 'Makalah Integral Riemann',
        description:
            'Tulis makalah 10–15 halaman tentang teorema fundamental kalkulus beserta contoh penerapannya dalam Analisis Real.',
        deadline: dl(11),
        attachmentUrl: null,
        createdBy: 1,
      ),
      TaskModel(
        id: 5,
        subjectId: 4,
        subjectName: 'Pemrograman Komputer',
        subjectCode: 'MTK-404',
        title: 'Project Akhir: Aplikasi CLI',
        description:
            'Buat program CLI berbasis Python atau C++ yang menyelesaikan satu permasalahan nyata. Kumpulkan beserta dokumentasi README.',
        deadline: dl(21),
        attachmentUrl: 'https://classroom.google.com/c/proj-akhir-mtk404',
        createdBy: 1,
      ),
    ];

    state = state.copyWith(tasks: dummy, isLoading: false);
    _loaded = true;
  }

  Future<void> createTask({
    required int subjectId,
    required String subjectName,
    String? subjectCode,
    required String title,
    String? description,
    required DateTime deadline,
    String? attachmentUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newId = state.tasks.isEmpty
        ? 1
        : state.tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    final task = TaskModel(
      id: newId,
      subjectId: subjectId,
      subjectName: subjectName,
      subjectCode: subjectCode,
      title: title,
      description: description?.isEmpty == true ? null : description,
      deadline: deadline,
      attachmentUrl: attachmentUrl?.isEmpty == true ? null : attachmentUrl,
      createdBy: 1,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(tasks: [...state.tasks, task]);
  }

  Future<void> updateTask(
    int id, {
    int? subjectId,
    String? subjectName,
    String? subjectCode,
    String? title,
    String? description,
    DateTime? deadline,
    String? attachmentUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      tasks: state.tasks.map((t) {
        if (t.id != id) return t;
        return t.copyWith(
          subjectId: subjectId,
          subjectName: subjectName,
          subjectCode: subjectCode,
          title: title,
          description: description?.isEmpty == true ? null : description,
          deadline: deadline,
          attachmentUrl:
              attachmentUrl?.isEmpty == true ? null : attachmentUrl,
          updatedAt: DateTime.now(),
        );
      }).toList(),
    );
  }

  Future<void> deleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      tasks: state.tasks.where((t) => t.id != id).toList(),
    );
  }
}

final taskProvider =
    StateNotifierProvider.family<TaskNotifier, TaskState, int>(
  (ref, classId) => TaskNotifier(classId),
);

final taskListProvider = Provider.family<List<TaskModel>, int>(
  (ref, classId) {
    final tasks = ref.watch(taskProvider(classId)).tasks;
    final sorted = [...tasks]..sort((a, b) => a.deadline.compareTo(b.deadline));
    return List.unmodifiable(sorted);
  },
);

final taskByIdProvider =
    Provider.family<TaskModel?, ({int classId, int taskId})>(
  (ref, params) {
    final tasks = ref.watch(taskListProvider(params.classId));
    return tasks.cast<TaskModel?>().firstWhere(
          (t) => t?.id == params.taskId,
          orElse: () => null,
        );
  },
);
