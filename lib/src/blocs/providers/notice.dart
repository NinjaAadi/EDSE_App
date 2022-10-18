import 'package:flutter/material.dart';
import '../blocs/notice.dart';

class NoticeProvider extends InheritedWidget {
  late final NoticeBloc noticeBloc;

  NoticeProvider({Key? key, Widget? child})
      : noticeBloc = NoticeBloc(),
        super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  static NoticeBloc of(BuildContext context) {
    return ((context.dependOnInheritedWidgetOfExactType<NoticeProvider>()
            as NoticeProvider)
        .noticeBloc);
  }
}
