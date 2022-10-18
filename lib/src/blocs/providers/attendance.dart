import 'package:edse_app/src/blocs/blocs/attendance.dart';
import 'package:flutter/material.dart';

class AttendanceProvider extends InheritedWidget {
  late final AttendanceBloc attendanceBloc;

  AttendanceProvider({Key? key, Widget? child})
      : attendanceBloc = AttendanceBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AttendanceBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<AttendanceProvider>()
            as AttendanceProvider)
        .attendanceBloc);
  }
}
