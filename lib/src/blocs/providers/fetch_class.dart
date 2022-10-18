import 'package:flutter/material.dart';
import '../blocs/fetch_class.dart';

class FetchClassProvider extends InheritedWidget {
  late final FetchClassBloc fetchClassBloc;

  FetchClassProvider({Key? key, Widget? child})
      : fetchClassBloc = FetchClassBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static FetchClassBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<FetchClassProvider>()
            as FetchClassProvider)
        .fetchClassBloc);
  }
}
