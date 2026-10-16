import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaknaw/helper/scroll_motion.dart';

void main() {
  Widget fixture({bool reduced = false}) => MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduced),
          child: const Scaffold(
            body: SmoothScroll(
              child: SingleChildScrollView(
                primary: true,
                child: Column(children: [
                  ScrollFade(child: SizedBox(height: 600, child: Text('Hero'))),
                  ScrollFade(
                      child: SizedBox(height: 600, child: Text('Research'))),
                  ScrollFade(
                      child: SizedBox(height: 1800, child: Text('About'))),
                ]),
              ),
            ),
          ),
        ),
      );

  testWidgets('wheel eases, accumulates and reverses without overshooting',
      (tester) async {
    await tester.pumpWidget(fixture());
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    position.pointerScroll(120);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(position.pixels, greaterThan(0));
    expect(position.pixels, lessThan(120));
    position.pointerScroll(120);
    await tester.pumpAndSettle();
    expect(position.pixels, closeTo(240, .1));
    position.pointerScroll(-120);
    await tester.pumpAndSettle();
    expect(position.pixels, closeTo(120, .1));
    position.pointerScroll(-1000);
    await tester.pumpAndSettle();
    expect(position.pixels, 0);
  });

  testWidgets('section fades out and returns to full opacity on scroll back',
      (tester) async {
    await tester.pumpWidget(fixture());
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    int heroAlpha() => tester.layers.whereType<OpacityLayer>().first.alpha!;
    expect(heroAlpha(), 255);
    position.jumpTo(400);
    await tester.pump();
    expect(heroAlpha(), lessThan(255));
    expect(heroAlpha(), greaterThan(0));
    position.jumpTo(0);
    await tester.pump();
    expect(heroAlpha(), 255);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion keeps scrolling immediate and sections opaque',
      (tester) async {
    await tester.pumpWidget(fixture(reduced: true));
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable)).position;
    position.pointerScroll(120);
    expect(position.pixels, 120);
    await tester.pump();
    expect(tester.layers.whereType<OpacityLayer>(), isEmpty);
  });
}
