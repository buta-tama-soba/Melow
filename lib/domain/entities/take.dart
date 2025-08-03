import 'package:freezed_annotation/freezed_annotation.dart';

part 'take.freezed.dart';
part 'take.g.dart';

@freezed
class Take with _$Take {
  const factory Take({
    required String id,
    required String title,
    required DateTime createdAt,
    required int noteCount,
    required bool isFavorite,
    String? lyricsId,
    List<Note>? notes,
    Map<String, dynamic>? metadata,
  }) = _Take;

  factory Take.fromJson(Map<String, dynamic> json) => _$TakeFromJson(json);
}

@freezed
class Note with _$Note {
  const factory Note({
    required String note,
    required double duration,
    required double timing,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}