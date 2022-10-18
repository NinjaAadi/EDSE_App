class CourseModel {
  late final String id;
  late final String name;
  late final String subjectCode;
  late final String description;
  CourseModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    name = parsedJson["name"];
    subjectCode = parsedJson["subjectCode"];
    description = parsedJson["description"];
  }
}
