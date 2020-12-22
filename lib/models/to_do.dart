class ToDoModel {
  int id;
  String content;
  ToDoModel(this.content, this.id);
  ToDoModel.fromJson(jsonObject) {
    content = jsonObject['content'];
    id = jsonObject['id'];
  }
}
