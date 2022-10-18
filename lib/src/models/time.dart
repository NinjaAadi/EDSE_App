class TimeModel {
  late final String id;
  late final String startTime;
  late final String endTime;
  TimeModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    startTime = parsedJson["startTime"];
    endTime = parsedJson["endTime"];
  }
}
