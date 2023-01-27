import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class BottomBarDecoration extends StatelessWidget {
  const BottomBarDecoration({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 11, right: 11, top: 8, bottom: 2),
        child: BackgroundCard(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
