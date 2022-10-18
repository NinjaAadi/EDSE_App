import 'package:flutter/material.dart';
import '../blocs/class_students.dart';

class ClassStudentsProvider extends InheritedWidget {
  late final ClassStudentsBloc classStudentBloc;

  ClassStudentsProvider({Key? key, Widget? child})
      : classStudentBloc = ClassStudentsBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static ClassStudentsBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<ClassStudentsProvider>()
            as ClassStudentsProvider)
        .classStudentBloc);
  }
}
