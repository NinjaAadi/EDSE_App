import 'package:edse_app/src/blocs/providers/add_notice.dart';
import 'package:edse_app/src/blocs/providers/add_role.dart';
import 'package:edse_app/src/blocs/providers/notice.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:flutter/material.dart';
import './router/router.dart' as router;
import './blocs/providers/login.dart';
import './blocs/providers/transport.dart';
import './blocs/providers/teacher_time_table.dart';
import './blocs/providers/notice.dart';
import './blocs/providers/teacher_profile.dart';
import './blocs/providers/fetch_class.dart';
import './blocs/providers/class_students.dart';
import './blocs/providers/student_profile.dart';
import './blocs/providers/attendance.dart';
import 'blocs/providers/add_course.dart';
import 'blocs/providers/add_profile/non_teaching_staff.dart';
import 'blocs/providers/add_profile/student.dart';
import 'blocs/providers/add_profile/teacher.dart';
import 'blocs/providers/add_timetable/add_class_timetable.dart';
import 'blocs/providers/add_timetable/add_teacher_timetable.dart';
import 'blocs/providers/add_transport.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: TransportProvider(
        child: NoticeProvider(
          child: TeacherTimeTableProvider(
            child: TeacherProfileProvider(
              child: FetchClassProvider(
                child: ClassStudentsProvider(
                  child: StudentProfileProvider(
                    child: AttendanceProvider(
                      child: AddStudentProfileProvider(
                        child: AddTeacherProfileProvider(
                          child: AddNonTeachingStaffProfileProvider(
                            child: AddTeacherTimeTableProvider(
                              child: AddClassTimeTableProvider(
                                child: AddCourseProvider(
                                  child: AddTransportProvider(
                                    child: AddRoleProvider(
                                      child: AddNoticeProvider(
                                        child: const MaterialApp(
                                          debugShowCheckedModeBanner: false,
                                          title: "EDSE",
                                          onGenerateRoute:
                                              router.generateRoutes,
                                          initialRoute: LoginRoute,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
