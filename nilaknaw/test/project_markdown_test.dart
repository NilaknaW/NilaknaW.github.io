import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaknaw/helper/project_markdown.dart';

void main() {
  for (final width in [800.0, 320.0]) {
    testWidgets('markdown image dimensions fit a $width pixel reading area',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
          width: width,
          child: const ProjectMarkdown(
            data: '![500 Circuit](assets/images/favicon.png)\n\n'
                '![600x300 Layout](assets/images/favicon.png)\n\n'
                '![x200 Portrait](assets/images/favicon.png)\n\n'
                '![Diagram](assets/images/favicon.png#400x100)\n\n'
                '![Natural image](assets/images/favicon.png)',
          ),
        )),
      )));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images, hasLength(5));
      expect(images[0].width, width < 500 ? width : 500);
      expect(images[0].height, isNull);
      expect(images[0].semanticLabel, 'Circuit');
      final scaledWidth = width < 600 ? width : 600.0;
      expect(images[1].width, scaledWidth);
      expect(images[1].height, scaledWidth / 2);
      expect(images[2].width, isNull);
      expect(images[2].height, 200);
      expect(images[3].width, width < 400 ? width : 400);
      expect(images[3].height, (width < 400 ? width : 400) / 4);
      expect(images[4].width, isNull);
      expect(images[4].height, isNull);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('op-amp URLs display in full and retain their destinations',
      (tester) async {
    const repository = 'https://github.com/NilaknaW/sky130_op_amp';
    const tapeout = 'https://tinytapeout.com/chips/ttsky25b/tt_um_se_opamps';
    String? destination;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: SingleChildScrollView(
          child: ProjectMarkdown(
        data: 'Github repository: [$repository]($repository)\n\n'
            'Tapeout submission: [$tapeout]($tapeout)\n\n'
            '*Italic text* and **bold text**.',
        onTapLink: (text, href, title) => destination = href,
      )),
    )));
    for (final url in [repository, tapeout]) {
      final link = find.textContaining(url, findRichText: true);
      expect(link, findsOneWidget);
      final richText = tester.widget<RichText>(link);
      // Tap the linked span, which shares its paragraph with the preceding label.
      final box = tester.renderObject<RenderParagraph>(link);
      final text = richText.text.toPlainText();
      final start = text.indexOf(url);
      final boxes = box.getBoxesForSelection(
          TextSelection(baseOffset: start, extentOffset: start + url.length));
      final rect = boxes.first.toRect();
      await tester.tapAt(box.localToGlobal(rect.center));
      expect(destination, url);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('equations remain supported alongside Markdown links',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: SingleChildScrollView(
          child: ProjectMarkdown(
        data: r'Inline $x_1(t)$ and \(y^2\).'
            '\n\n'
            r'\[x_1 + x_2 = y\]'
            '\n\n'
            r'$$\sum_{k=0}^{n} k$$',
      )),
    )));
    expect(find.byType(Math), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });
}
