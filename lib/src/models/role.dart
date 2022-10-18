class RoleModel {
  late final String id;
  late final String title;
  late final String For;
  RoleModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    title = parsedJson["title"];
    For = parsedJson["for"];
  }
}
