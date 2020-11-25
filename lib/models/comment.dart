class Comment {
  int id;
  String content;
  String posterName;
  String date;

  Comment(this.id, this.content, this.posterName, this.date);

  Comment.fromJson(jsonObject) {
    id = jsonObject['id'];
    content = jsonObject['content'];
    posterName = jsonObject['posterName'];
    date = jsonObject['date'];
  }
}
