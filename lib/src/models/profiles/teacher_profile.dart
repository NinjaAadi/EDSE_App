import 'package:edse_app/src/models/course.dart';
import 'package:edse_app/src/models/role.dart';
import 'package:edse_app/src/models/transport.dart';

class TeacherProfileModel {
  late final String id;
  late final String profileImageURL;
  late final String fullName;
  late final String address;
  late final String phoneNumber;
  late final String birthDay;
  late final String gender;
  late final List<RoleModel> role;
  late final List<CourseModel> courses;
  late final List<TransportModel> transport;
  TeacherProfileModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    profileImageURL = parsedJson["profileImageURL"];
    fullName = parsedJson["fullName"];
    address = parsedJson["address"];
    phoneNumber = parsedJson["phoneNumber"];
    birthDay = parsedJson["birthDay"];
    gender = parsedJson["gender"];

    List<RoleModel> roleList = [];
    for (var i = 0; i < parsedJson["role"].length; i++) {
      roleList.add(RoleModel.fromJson(parsedJson["role"][i]));
    }
    role = roleList;

    List<CourseModel> courseList = [];
    for (var i = 0; i < parsedJson["courses"].length; i++) {
      courseList.add(CourseModel.fromJson(parsedJson["courses"][i]));
    }
    courses = courseList;

    List<TransportModel> transportList = [];
    for (var i = 0; i < parsedJson["transportAddress"].length; i++) {
      transportList
          .add(TransportModel.fromJson(parsedJson["transportAddress"][i]));
    }
    transport = transportList;
  }
}
