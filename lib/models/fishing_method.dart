class FishingMethod {
  int id;
  String name;
  FishingMethod({this.id, this.name});
  factory FishingMethod.fromJson(Map<String, dynamic> json) {
    return FishingMethod(id: json['id'], name: json['name']);
  }
}
