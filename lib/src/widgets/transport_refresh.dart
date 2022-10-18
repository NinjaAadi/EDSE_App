import 'package:flutter/material.dart';
import '../blocs/providers/transport.dart';
import 'dart:async';

class Refresh extends StatelessWidget {
  final Widget child;
  Refresh({required this.child});
  Widget build(context) {
    final transportBloc = TransportProvider.of(context);
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          await transportBloc.fetchTransport();
        });
  }
}
