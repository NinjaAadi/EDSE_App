import 'package:flutter/material.dart';
import '../blocs/login.dart';

class LoginProvider extends InheritedWidget {
  late final LoginBloc loginBloc;

  LoginProvider({Key? key, Widget? child})
      : loginBloc = LoginBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<LoginProvider>()
            as LoginProvider)
        .loginBloc);
  }
}
