class Note {
  int? id;
  String title;
  String content;
  String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert a Note into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  // Extract a Note object from a Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
    );
  }
}
