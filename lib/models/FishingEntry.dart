class FishingEntry {
  int id;
  String name;
  String img;
  String description;
  String nameOfThePlace;
  String dateTime;
  String methods;
  String fishes;
  String details;
  FishingEntry(
      this.id,
      this.name,
      this.img,
      this.description,
      this.nameOfThePlace,
      this.dateTime,
      this.methods,
      this.fishes,
      this.details);

  FishingEntry.fromJson(jsonObject) {
    id = jsonObject['id'];
    name = jsonObject['title'];
    img = jsonObject['fileData'];
    description = jsonObject['description'];
    nameOfThePlace = jsonObject['place'];
    dateTime = jsonObject['date'];
    methods = jsonObject['methods'];
    fishes = jsonObject['fishes'];
    details = jsonObject['details'];
  }
}
