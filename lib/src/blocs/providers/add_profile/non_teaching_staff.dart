import 'package:edse_app/src/blocs/blocs/add_profile/non_teaching_staff.dart';
import 'package:edse_app/src/blocs/blocs/add_profile/teacher.dart';
import 'package:flutter/material.dart';

class AddNonTeachingStaffProfileProvider extends InheritedWidget {
  late final AddNonTeachingStaffProfileBloc addNonTeachingStaffProfileBloc;

  AddNonTeachingStaffProfileProvider({Key? key, Widget? child})
      : addNonTeachingStaffProfileBloc = AddNonTeachingStaffProfileBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddNonTeachingStaffProfileBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<
                AddNonTeachingStaffProfileProvider>()
            as AddNonTeachingStaffProfileProvider)
        .addNonTeachingStaffProfileBloc);
  }
}
