import 'package:edse_app/src/models/profiles/student_profile.dart';

class ClassModel {
  late final String id;
  late final String name;
  late final String teacher;
  late final List<StudentProfileModel> students;
  ClassModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    name = parsedJson["name"];
    teacher = parsedJson["teacher"];
    List<StudentProfileModel> tempStudents = [];
    for (var i = 0; i < parsedJson["students"].length; i++) {
      tempStudents.add(StudentProfileModel.fromJson(parsedJson["students"][i]));
    }

    students = tempStudents;
  }
}
