import 'package:edse_app/src/blocs/blocs/add_course.dart';
import 'package:flutter/material.dart';

class AddCourseProvider extends InheritedWidget {
  late final AddCourseBloc addCourseBloc;

  AddCourseProvider({Key? key, Widget? child})
      : addCourseBloc = AddCourseBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddCourseBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<AddCourseProvider>()
            as AddCourseProvider)
        .addCourseBloc);
  }
}
