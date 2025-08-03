class Take {
  final String id;
  final String title;
  final DateTime createdAt;
  final int noteCount;
  final bool isFavorite;
  final String? lyricsId;
  final List<Note>? notes;
  final Map<String, dynamic>? metadata;

  const Take({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.noteCount,
    required this.isFavorite,
    this.lyricsId,
    this.notes,
    this.metadata,
  });

  Take copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    int? noteCount,
    bool? isFavorite,
    String? lyricsId,
    List<Note>? notes,
    Map<String, dynamic>? metadata,
  }) {
    return Take(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      noteCount: noteCount ?? this.noteCount,
      isFavorite: isFavorite ?? this.isFavorite,
      lyricsId: lyricsId ?? this.lyricsId,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}

class Note {
  final String note;
  final double duration;
  final double timing;

  const Note({
    required this.note,
    required this.duration,
    required this.timing,
  });
}