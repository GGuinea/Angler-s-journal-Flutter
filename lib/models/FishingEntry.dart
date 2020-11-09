class FishingEntry {
  int id;
  String name;
  String img;
  String description;
  String nameOfThePlace;
  String dateTime;
  FishingEntry(this.id, this.name, this.img, this.description,
      this.nameOfThePlace, this.dateTime);

  FishingEntry.fromJson(jsonObject) {
    id = jsonObject['id'];
    name = jsonObject['title'];
    img = jsonObject['fileData'];
    description = jsonObject['description'];
    nameOfThePlace = jsonObject['place'];
    dateTime = jsonObject['date'];
  }
}
