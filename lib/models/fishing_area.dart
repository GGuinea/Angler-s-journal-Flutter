import 'package:NotatnikWedkarza/models/comment.dart';

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
    var list = jsonObject['comments'];
    comments = list.cast<Comment>();
  }
}
