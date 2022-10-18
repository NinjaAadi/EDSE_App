import 'package:edse_app/src/models/class.dart';
import 'package:edse_app/src/models/course.dart';
import 'package:edse_app/src/models/time.dart';

class TeacherPeriodModel {
  late final TimeModel time;
  late final CourseModel subject;
  late final ClassModel className;
  TeacherPeriodModel.fromJson(parsedJson) {
    time = TimeModel.fromJson(parsedJson["time"]);
    subject = CourseModel.fromJson(parsedJson["subject"]);
    className = ClassModel.fromJson(parsedJson["className"]);
  }
}
