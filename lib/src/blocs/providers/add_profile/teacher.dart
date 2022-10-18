import 'package:edse_app/src/blocs/blocs/add_profile/teacher.dart';
import 'package:flutter/material.dart';

class AddTeacherProfileProvider extends InheritedWidget {
  late final AddTeacherProfileBloc addTeacherProfileBloc;

  AddTeacherProfileProvider({Key? key, Widget? child})
      : addTeacherProfileBloc = AddTeacherProfileBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddTeacherProfileBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<AddTeacherProfileProvider>()
            as AddTeacherProfileProvider)
        .addTeacherProfileBloc);
  }
}
