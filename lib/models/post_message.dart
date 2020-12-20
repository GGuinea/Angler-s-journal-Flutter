class PostMessage {
  int id;
  String content;
  String date;
  String time;
  String author;
  bool isMarker;

  PostMessage(
      {this.id,
      this.content,
      this.date,
      this.time,
      this.author,
      this.isMarker});
  factory PostMessage.fromJson(Map<String, dynamic> json) {
    return PostMessage(
        id: json['id'],
        content: json['content'],
        date: json['date'],
        time: json['time'],
        author: json['author'],
        isMarker: json['marker']);
  }
}
