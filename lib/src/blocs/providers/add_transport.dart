import 'package:edse_app/src/blocs/blocs/add_transport.dart';
import 'package:flutter/material.dart';

class AddTransportProvider extends InheritedWidget {
  late final AddTransportBloc addTransportBloc;

  AddTransportProvider({Key? key, Widget? child})
      : addTransportBloc = AddTransportBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddTransportBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<AddTransportProvider>()
            as AddTransportProvider)
        .addTransportBloc);
  }
}
