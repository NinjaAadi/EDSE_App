import 'package:flutter/material.dart';
import '../blocs/providers/notice.dart';
import 'dart:async';

class NoticeRefresh extends StatelessWidget {
  final Widget child;
  final String forDept;
  NoticeRefresh({required this.child, required this.forDept});
  Widget build(context) {
    final noticeBloc = NoticeProvider.of(context);
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          await noticeBloc.fetchNotice(forDept);
        });
  }
}
