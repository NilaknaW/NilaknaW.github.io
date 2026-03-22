import 'package:flutter/material.dart';

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width > 1000
        ? 64
        : width > 600
            ? 32
            : 16;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
