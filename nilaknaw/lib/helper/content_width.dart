import 'package:flutter/material.dart';

// Apply inside scroll views or section backgrounds, never around the viewport.
double contentInset(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width >= 1200 ? width * 0.1 : 0;
}
