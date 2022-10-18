import 'package:edse_app/src/blocs/blocs/add_role.dart';
import 'package:flutter/material.dart';

class AddRoleProvider extends InheritedWidget {
  late final AddRoleBloc addRoleBloc;

  AddRoleProvider({Key? key, Widget? child})
      : addRoleBloc = AddRoleBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddRoleBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<AddRoleProvider>()
            as AddRoleProvider)
        .addRoleBloc);
  }
}
