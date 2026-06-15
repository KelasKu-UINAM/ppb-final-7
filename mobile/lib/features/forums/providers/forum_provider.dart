import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forum_model.dart';
import '../models/message_model.dart';

// ── Forum list state (per class) ───────────────────────────────

@immutable
class ForumState {
  final List<ForumModel> forums;
  final bool isLoading;
  final String? error;

  const ForumState({
    this.forums = const [],
    this.isLoading = false,
    this.error,
  });

  ForumState copyWith({
    List<ForumModel>? forums,
    bool? isLoading,
    String? error,
  }) {
    return ForumState(
      forums: forums ?? this.forums,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ForumNotifier extends StateNotifier<ForumState> {
  ForumNotifier(this._classId) : super(const ForumState());

  final int _classId;
  bool _loaded = false;

  Future<void> fetchForums({bool forceRefresh = false}) async {
    if (_loaded && !forceRefresh) return;
    state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (_classId != 1) {
      state = state.copyWith(forums: const [], isLoading: false);
      _loaded = true;
      return;
    }

    final base = DateTime.now().subtract(const Duration(days: 5));
    final dummy = [
      ForumModel(
        id: 1,
        classId: 1,
        subjectId: null,
        type: 'class',
        name: 'Forum Kelas SI 4A',
        subjectName: null,
        createdAt: base,
      ),
      ForumModel(
        id: 2,
        classId: 1,
        subjectId: 1,
        type: 'subject',
        name: 'Diskusi Pemrograman Mobile',
        subjectName: 'Analisis Real',
        createdAt: base.add(const Duration(days: 1)),
      ),
    ];

    state = state.copyWith(forums: dummy, isLoading: false);
    _loaded = true;
  }

  Future<void> createForum({
    required String type,
    required String name,
    int? subjectId,
    String? subjectName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final newId = state.forums.isEmpty
        ? 1
        : state.forums.map((f) => f.id).reduce((a, b) => a > b ? a : b) + 1;
    final forum = ForumModel(
      id: newId,
      classId: _classId,
      subjectId: type == 'subject' ? subjectId : null,
      type: type,
      name: name,
      subjectName: type == 'subject' ? subjectName : null,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(forums: [...state.forums, forum]);
  }
}

final forumProvider =
    StateNotifierProvider.family<ForumNotifier, ForumState, int>(
  (ref, classId) => ForumNotifier(classId),
);

// Sorted oldest-first (mirrors backend ORDER BY created_at ASC).
final forumListProvider = Provider.family<List<ForumModel>, int>((ref, classId) {
  final forums = ref.watch(forumProvider(classId)).forums;
  final sorted = [...forums]..sort(
      (a, b) =>
          (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)),
    );
  return List.unmodifiable(sorted);
});

final forumByIdProvider =
    Provider.family<ForumModel?, ({int classId, int forumId})>(
  (ref, params) {
    final forums = ref.watch(forumListProvider(params.classId));
    return forums.cast<ForumModel?>().firstWhere(
          (f) => f?.id == params.forumId,
          orElse: () => null,
        );
  },
);

// ── Message state (per forum) ──────────────────────────────────

@immutable
class MessageState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? error;

  const MessageState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  MessageState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MessageNotifier extends StateNotifier<MessageState> {
  MessageNotifier(this._forumId) : super(const MessageState());

  final int _forumId;
  bool _loaded = false;

  /// [silent] is used by the 5-second polling timer so the loading spinner
  /// is not toggled on every refresh. Once loaded, dummy data is preserved
  /// (so sent messages survive polling). In Phase 11 this re-fetches from API.
  Future<void> fetchMessages({bool silent = false}) async {
    if (_loaded) {
      // Polling no-op in dummy phase — real API will merge new messages here.
      return;
    }
    if (!silent) state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    state = state.copyWith(messages: _dummyFor(_forumId), isLoading: false);
    _loaded = true;
  }

  List<MessageModel> _dummyFor(int forumId) {
    final now = DateTime.now();
    DateTime ago(int minutes) => now.subtract(Duration(minutes: minutes));

    if (forumId == 1) {
      return [
        MessageModel(
          id: 1,
          forumId: 1,
          senderId: 1,
          senderName: 'Admin Kelas',
          message: 'Assalamualaikum, selamat datang di forum kelas SI 4A 🎉',
          createdAt: ago(240),
        ),
        MessageModel(
          id: 2,
          forumId: 1,
          senderId: 3,
          senderName: 'Mahasiswa Kelas',
          message: 'Waalaikumsalam kak, siap! 🙌',
          createdAt: ago(232),
        ),
        MessageModel(
          id: 3,
          forumId: 1,
          senderId: 2,
          senderName: 'Bendahara Kelas',
          message:
              'Jangan lupa iuran minggu ini ya teman-teman, cek di menu Iuran 🙏',
          createdAt: ago(120),
        ),
        MessageModel(
          id: 4,
          forumId: 1,
          senderId: 1,
          senderName: 'Admin Kelas',
          message: 'Betul, mohon dilunasi sebelum akhir pekan.',
          createdAt: ago(118),
        ),
      ];
    }

    if (forumId == 2) {
      return [
        MessageModel(
          id: 1,
          forumId: 2,
          senderId: 1,
          senderName: 'Admin Kelas',
          message: 'Diskusi tugas Pemrograman Mobile kita taruh di sini ya.',
          createdAt: ago(180),
        ),
        MessageModel(
          id: 2,
          forumId: 2,
          senderId: 3,
          senderName: 'Mahasiswa Kelas',
          message: 'Kak, untuk state management sebaiknya pakai apa?',
          createdAt: ago(60),
        ),
      ];
    }

    return const [];
  }

  Future<void> sendMessage({
    required int senderId,
    required String senderName,
    required String message,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    final newId = state.messages.isEmpty
        ? 1
        : state.messages.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
    final msg = MessageModel(
      id: newId,
      forumId: _forumId,
      senderId: senderId,
      senderName: senderName,
      message: trimmed,
      createdAt: DateTime.now(),
    );
    // Append (newest at bottom — chat order).
    state = state.copyWith(messages: [...state.messages, msg]);
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}

final messageProvider =
    StateNotifierProvider.family<MessageNotifier, MessageState, int>(
  (ref, forumId) => MessageNotifier(forumId),
);
