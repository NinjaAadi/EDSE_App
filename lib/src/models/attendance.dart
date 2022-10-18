class AttendanceModel {
  late final String day;
  late final bool isPresent;
  AttendanceModel.fromJson(parsedJson) {
    day = parsedJson["day"];
    isPresent = parsedJson["isPresent"];
  }
}
