import 'package:flutter/material.dart';
import 'scroll_motion.dart';
import 'project_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';
// import 'package:markdown/markdown.dart' as md;
// import 'package:flutter_markdown/flutter_markdown.dart';

class Project {
  final String title;
  final String imagePath;
  final String markdownAssetPath;

  const Project({
    required this.title,
    required this.imagePath,
    required this.markdownAssetPath,
  });
}

class ProjectTile extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectTile({super.key, required this.project, required this.onTap});

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ResizeImage.resizeIfNeeded(
                      800, null, AssetImage(widget.project.imagePath)),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _hovering ? Colors.black45 : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.project.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              //  _hovering
              //   ? Text(
              //       widget.project.title,
              //       style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.center,
              //     )
              //   : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// Compatibility for older entry points; Projects embeds ProjectReader directly.
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(project.title)),
        body: SmoothScroll(child: ProjectReader(project: project)),
      );
}

class ProjectReader extends StatefulWidget {
  const ProjectReader({super.key, required this.project});
  final Project project;

  @override
  State<ProjectReader> createState() => _ProjectReaderState();
}

class _ProjectReaderState extends State<ProjectReader> {
  AssetBundle? _bundle;
  late Future<String> _markdown;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bundle = DefaultAssetBundle.of(context);
    if (_bundle != bundle) {
      _bundle = bundle;
      _load();
    }
  }

  @override
  void didUpdateWidget(ProjectReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.markdownAssetPath !=
        widget.project.markdownAssetPath) {
      _load();
    }
  }

  void _load() {
    _markdown = _bundle!.loadString(widget.project.markdownAssetPath);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: _markdown,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load these notes.'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(_load),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ));
          }
          final compact = MediaQuery.sizeOf(context).width < 600;
          return ColoredBox(
            color: const Color(0xFFF7FAF9),
            child: SingleChildScrollView(
              primary: true,
              padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 32, vertical: compact ? 16 : 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0EBE8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 20 : 48),
                      child: SelectionArea(
                        child: ProjectMarkdown(
                          data: snapshot.data!,
                          onTapLink: (text, href, title) async {
                            final uri = Uri.tryParse(href ?? '');
                            if (uri != null && await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
