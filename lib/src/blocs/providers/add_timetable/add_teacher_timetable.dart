import 'package:edse_app/src/blocs/blocs/add_timetable/add_teacher_timetable.dart';
import 'package:flutter/material.dart';

class AddTeacherTimeTableProvider extends InheritedWidget {
  late final AddTeacherTimeTableBloc addTeacherTimeTableBloc;

  AddTeacherTimeTableProvider({Key? key, Widget? child})
      : addTeacherTimeTableBloc = AddTeacherTimeTableBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddTeacherTimeTableBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<
            AddTeacherTimeTableProvider>() as AddTeacherTimeTableProvider)
        .addTeacherTimeTableBloc);
  }
}
