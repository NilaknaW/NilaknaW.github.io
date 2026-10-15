import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaknaw/pages/home.dart';

void main() {
  for (final size in [
    const Size(1024, 600),
    const Size(1280, 600),
    const Size(1366, 768),
    const Size(1440, 900),
  ]) {
    testWidgets('hero tools fit without scrolling at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: AppBar(toolbarHeight: 80),
          body: SizedBox.expand(child: HomeTab()),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      final tools = find.byType(Tooltip);
      expect(tools, findsNWidgets(16));
      for (final element in tools.evaluate()) {
        final bounds = tester.getRect(find.byWidget(element.widget));
        expect(bounds.top, greaterThanOrEqualTo(80));
        expect(bounds.bottom, lessThanOrEqualTo(size.height));
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
