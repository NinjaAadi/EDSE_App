import 'package:edse_app/src/router/route_constants.dart';
import 'package:edse_app/src/screens/class/show_class.dart';
import 'package:edse_app/src/screens/class/show_student_list.dart';
import 'package:edse_app/src/screens/course/add_course.dart';
import 'package:edse_app/src/screens/login.dart';
import 'package:edse_app/src/screens/notice/add_notice.dart';
import 'package:edse_app/src/screens/notice/show_notice/show_notice.dart';
import 'package:edse_app/src/screens/profile/add_profile.dart';
import 'package:edse_app/src/screens/profile/non_teaching_staff_add_profile.dart';
import 'package:edse_app/src/screens/profile/student_add_profile.dart';
import 'package:edse_app/src/screens/profile/student_profile.dart';
import 'package:edse_app/src/screens/profile/teacher_add_profile.dart';
import 'package:edse_app/src/screens/review/add_review.dart';
import 'package:edse_app/src/screens/role/add_role.dart';
import 'package:edse_app/src/screens/timetable/add_class_timetable.dart';
import 'package:edse_app/src/screens/timetable/add_teacher_time.dart';
import 'package:edse_app/src/screens/timetable/add_timetable.dart';
import 'package:edse_app/src/screens/transport/add_transport.dart';
import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/teacher/home.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => Login());
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => AdminHome());
    case NoticeRoute:
      return MaterialPageRoute(builder: (context) => ShowNotice());
    case ShowAllClass:
      return MaterialPageRoute(builder: (context) => TeacherClasses());
    case ShowAllStudentsForClass:
      return MaterialPageRoute(builder: (context) => ShowStudentList());
    case StudentProfileRoute:
      return MaterialPageRoute(builder: (context) => StudentProfile());
    case AddProfileRoute:
      return MaterialPageRoute(builder: (context) => AddProfile());
    case AddStudentProfileRoute:
      return MaterialPageRoute(builder: (context) => AddStudentProfile());
    case AddTeacherProfileRoute:
      return MaterialPageRoute(builder: (context) => AddTeacherProfile());
    case AddNonTeachingStaffProfileRoute:
      return MaterialPageRoute(
          builder: (context) => AddNonTeachingStaffProfile());
    case AddTimeTableRoute:
      return MaterialPageRoute(builder: (context) => AddTimeTable());
    case AddTimeTableForTeacherRoute:
      return MaterialPageRoute(builder: (context) => AddTeacherTimeTable());
    case AddTimeTableForClassRoute:
      return MaterialPageRoute(builder: (context) => AddClassTimeTable());
    case AddCourseRoute:
      return MaterialPageRoute(builder: (context) => AddCourse());
    case AddTransportRoute:
      return MaterialPageRoute(builder: (context) => AddTransport());
    case AddRoleRoute:
      return MaterialPageRoute(builder: (context) => AddRole());
    case AddNoticeRoute:
      return MaterialPageRoute(builder: (context) => AddNotice());
    case AddReviewRoute:
      return MaterialPageRoute(builder: (context) => AddReview());
    default:
      return MaterialPageRoute(builder: (context) => Login());
  }
}
