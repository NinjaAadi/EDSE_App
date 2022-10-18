import 'package:edse_app/src/blocs/blocs/add_notice.dart';
import 'package:flutter/material.dart';

class AddNoticeProvider extends InheritedWidget {
  late final AddNoticeBloc addNoticeBloc;

  AddNoticeProvider({Key? key, Widget? child})
      : addNoticeBloc = AddNoticeBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static AddNoticeBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<AddNoticeProvider>()
            as AddNoticeProvider)
        .addNoticeBloc);
  }
}
