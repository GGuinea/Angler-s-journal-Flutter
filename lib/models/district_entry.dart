class DistrictEntry {
  String district;
  int areaCounter;

  DistrictEntry(this.district, this.areaCounter);
  DistrictEntry.fromJson(jsonObject) {
    district = jsonObject['district'];
    areaCounter = jsonObject['areaCounter'];
  }
}
