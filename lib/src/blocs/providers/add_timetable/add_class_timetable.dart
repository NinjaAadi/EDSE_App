import 'package:edse_app/src/blocs/blocs/add_timetable/add_class_timetable.dart';
import 'package:flutter/material.dart';

class AddClassTimeTableProvider extends InheritedWidget {
  late final AddClassTimeTableBloc addClassTimeTableBloc;

  AddClassTimeTableProvider({Key? key, Widget? child})
      : addClassTimeTableBloc = AddClassTimeTableBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddClassTimeTableBloc of(BuildContext context) {
    return ((context
                .dependOnInheritedWidgetOfExactType<AddClassTimeTableProvider>()
            as AddClassTimeTableProvider)
        .addClassTimeTableBloc);
  }
}
