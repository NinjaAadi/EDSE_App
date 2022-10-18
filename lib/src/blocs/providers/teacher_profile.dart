import 'package:edse_app/src/blocs/blocs/teacher_time_table.dart';
import 'package:flutter/material.dart';
import '../blocs/teacher_profile.dart';

class TeacherProfileProvider extends InheritedWidget {
  late final TeacherProfileBloc teacherProfileBloc;

  TeacherProfileProvider({Key? key, Widget? child})
      : teacherProfileBloc = TeacherProfileBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static TeacherProfileBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<TeacherProfileProvider>()
            as TeacherProfileProvider)
        .teacherProfileBloc);
  }
}
