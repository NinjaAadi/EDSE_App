import '../blocs/student_profile.dart';
import 'package:flutter/material.dart';
import '../blocs/teacher_profile.dart';

class StudentProfileProvider extends InheritedWidget {
  late final StudentProfileBloc studentProfileBloc;

  StudentProfileProvider({Key? key, Widget? child})
      : studentProfileBloc = StudentProfileBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static StudentProfileBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<StudentProfileProvider>()
            as StudentProfileProvider)
        .studentProfileBloc);
  }
}
