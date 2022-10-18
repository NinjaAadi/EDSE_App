import 'package:edse_app/src/blocs/blocs/add_profile/student.dart';
import 'package:flutter/material.dart';

class AddStudentProfileProvider extends InheritedWidget {
  late final AddStudentProfileBloc addStudentProfileBloc;

  AddStudentProfileProvider({Key? key, Widget? child})
      : addStudentProfileBloc = AddStudentProfileBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddStudentProfileBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<AddStudentProfileProvider>()
            as AddStudentProfileProvider)
        .addStudentProfileBloc);
  }
}
