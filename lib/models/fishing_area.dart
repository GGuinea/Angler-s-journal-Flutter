import 'package:notatinik_wedkarza/models/comment.dart';

class FishingArea {
  int id;
  String name;
  String district;
  String description;
  List<Comment> comments;

  FishingArea(
      this.id, this.name, this.district, this.description, this.comments);

  FishingArea.fromJson(jsonObject) {
    id = jsonObject['id'];
    name = jsonObject['name'];
    district = jsonObject['district'];
    description = jsonObject['description'];
    var tmp = jsonObject['comments'];
    print(tmp);
    comments = [];
    for (var model in tmp) {
      comments.add((Comment.fromJson(model)));
    }
  }
}
