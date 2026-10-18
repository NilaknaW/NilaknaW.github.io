import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

/// Parse links as Markdown nodes before interpreting emphasis inside text.
class ProjectMarkdown extends StatelessWidget {
  const ProjectMarkdown({super.key, required this.data, this.onTapLink});
  final String data;
  final MarkdownTapLinkCallback? onTapLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
        builder: (context, constraints) => MarkdownBody(
              data: data,
              onTapLink: onTapLink,
              extensionSet: md.ExtensionSet.gitHubFlavored,
              inlineSyntaxes: [_MathSyntax()],
              builders: {'math': _MathBuilder()},
              sizedImageBuilder: (image) =>
                  _markdownImage(image, constraints.maxWidth),
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: 17, height: 1.75),
                h1: theme.textTheme.headlineMedium?.copyWith(height: 1.3),
                h2: theme.textTheme.headlineSmall?.copyWith(height: 1.4),
                h3: theme.textTheme.titleLarge?.copyWith(height: 1.4),
                a: TextStyle(
                    color: Colors.teal.shade800,
                    decoration: TextDecoration.underline),
                blockSpacing: 20,
              ),
            ));
  }
}

Widget _markdownImage(MarkdownImageConfig image, double maxWidth) {
  // Preserve the size prefix supported by the existing project documents:
  // ![500 description], ![500x300 description], and ![x300 description].
  final alt = image.alt ?? '';
  final size =
      RegExp(r'^\s*(?:(\d+)(?:x(\d+))?|x(\d+))(?=\s|$)').firstMatch(alt);
  double? positive(double? value) => value != null && value > 0 ? value : null;
  final requestedWidth =
      positive(image.width) ?? positive(double.tryParse(size?.group(1) ?? ''));
  final requestedHeight = positive(image.height) ??
      positive(double.tryParse(size?.group(2) ?? size?.group(3) ?? ''));
  final scale = requestedWidth != null && requestedWidth > maxWidth
      ? maxWidth / requestedWidth
      : 1.0;
  final width = requestedWidth == null ? null : requestedWidth * scale;
  final height = requestedHeight == null ? null : requestedHeight * scale;
  final label = size == null ? alt : alt.substring(size.end).trim();
  Widget error(BuildContext context, Object error, StackTrace? stackTrace) =>
      SizedBox(
          width: width,
          height: height ?? 120,
          child: const Center(child: Icon(Icons.broken_image_outlined)));
  final uri = image.uri;
  final Widget content = uri.hasScheme
      ? Image.network(uri.toString(),
          width: width,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: label,
          errorBuilder: error)
      : Image.asset(uri.path,
          width: width,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: label,
          errorBuilder: error);
  return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth), child: content);
}

class _MathSyntax extends md.InlineSyntax {
  _MathSyntax()
      : super(
          r'\$\$([\s\S]+?)\$\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)|(?<!\\)\$([^\n$]+?)\$',
        );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final display = match[1] != null || match[2] != null;
    final element =
        md.Element.text('math', match[1] ?? match[2] ?? match[3] ?? match[4]!);
    element.attributes['display'] = '$display';
    parser.addNode(element);
    return true;
  }
}

class _MathBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfterWithContext(BuildContext context, md.Element element,
      TextStyle? preferredStyle, TextStyle? parentStyle) {
    final display = element.attributes['display'] == 'true';
    final math = Math.tex(element.textContent.trim(),
        mathStyle: display ? MathStyle.display : MathStyle.text,
        textStyle: parentStyle,
        onErrorFallback: (_) => Text(element.textContent));
    return display
        ? SingleChildScrollView(
            primary: false,
            scrollDirection: Axis.horizontal,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12), child: math))
        : math;
  }
}
