class Alarm {
  Duration time;
  bool isActive;
  bool repeat;
  String label;

  Alarm(Duration time, bool isActive, bool repeat, String label) {
    this.time = time;
    this.isActive = isActive;
    this.repeat = repeat;
    this.label = label;
  }
}
