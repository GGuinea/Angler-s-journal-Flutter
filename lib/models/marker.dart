class MarkerData {
  int id;
  double latitude;
  double longitude;
  String title;
  String description;

  MarkerData(
      this.id, this.latitude, this.longitude, this.title, this.description);

  MarkerData.fromJson(jsonObject) {
    id = jsonObject['id'];
    latitude = jsonObject['latitude'];
    longitude = jsonObject['longitude'];
    title = jsonObject['title'];
    description = jsonObject['description'];
  }
}
