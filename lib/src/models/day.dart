class DayModel {
  late final String id;
  late final String name;
  DayModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    name = parsedJson["name"];
  }
}
