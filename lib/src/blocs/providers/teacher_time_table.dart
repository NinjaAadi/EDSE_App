import 'package:flutter/material.dart';
import '../blocs/teacher_time_table.dart';

class TeacherTimeTableProvider extends InheritedWidget {
  late final TeacherTimeTableBloc teacherTimeTableBloc;

  TeacherTimeTableProvider({Key? key, Widget? child})
      : teacherTimeTableBloc = TeacherTimeTableBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static TeacherTimeTableBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<TeacherTimeTableProvider>()
            as TeacherTimeTableProvider)
        .teacherTimeTableBloc);
  }
}
