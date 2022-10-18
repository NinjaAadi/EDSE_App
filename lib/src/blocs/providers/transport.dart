import 'package:flutter/material.dart';
import '../blocs/transport.dart';

class TransportProvider extends InheritedWidget {
  late final TransportBloc transportBloc;

  TransportProvider({Key? key, Widget? child})
      : transportBloc = TransportBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static TransportBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<TransportProvider>()
            as TransportProvider)
        .transportBloc);
  }
}
