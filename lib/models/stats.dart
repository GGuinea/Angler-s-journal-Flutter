class Statistics {
  int fishes;
  int diaries;
  int markers;
  int level;

  Statistics(this.fishes, this.diaries, this.markers, this.level);
  Statistics.fromJson(jsonObject) {
    fishes = jsonObject['fishNumber'];
    diaries = jsonObject['diaryNumber'];
    level = jsonObject['currentLevel'];
    markers = jsonObject['savedMarkers'];
  }
}
