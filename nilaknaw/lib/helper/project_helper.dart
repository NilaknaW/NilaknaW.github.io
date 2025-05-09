import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gpt_markdown/gpt_markdown.dart';
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
                  image: AssetImage(widget.project.imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _hovering ? Colors.black45 : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: _hovering
                  ? Text(
                      widget.project.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  Future<String> loadMarkdown() async {
    return await rootBundle.loadString(project.markdownAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(title: Text(project.title, style: TextStyle(fontSize: 16))),
      body: FutureBuilder<String>(
        future: loadMarkdown(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading content'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GptMarkdown(
                  snapshot.data!,
                  onLinkTab: (url, title) async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint('Could not launch $url');
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// class ProjectDetailPage extends StatefulWidget {
//   final Project project;

//   const ProjectDetailPage({super.key, required this.project});

//   @override
//   State<ProjectDetailPage> createState() => _ProjectDetailPageState();
// }

// class _ProjectDetailPageState extends State<ProjectDetailPage> {
//   late final WebViewController _controller;
//   String? _htmlContent;

//   @override
//   void initState() {
//     super.initState();
//     _loadHtmlContent();
//   }

//   Future<void> _loadHtmlContent() async {
//     final markdown =
//         await rootBundle.loadString(widget.project.markdownAssetPath);
//     final htmlBody = md.markdownToHtml(markdown);
//     final fullHtml = '''
//     <!DOCTYPE html>
//     <html>
//       <head>
//         <meta charset="UTF-8">
//         <style>
//           body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
//           h1, h2, h3 { color: #333; }
//           code { background: #eee; padding: 2px 4px; border-radius: 4px; }
//           pre { background: #f4f4f4; padding: 12px; overflow-x: auto; border-radius: 4px; }
//           img { max-width: 100%; height: auto; }
//           a { color: #007BFF; }
//         </style>
//       </head>
//       <body>
//         $htmlBody
//       </body>
//     </html>
//     ''';

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadHtmlString(fullHtml); // Now controller is initialized safely

//     setState(() {
//       _htmlContent = fullHtml;
//     });

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadHtmlString(fullHtml);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title:
//               Text(widget.project.title, style: const TextStyle(fontSize: 16))),
//       body: _htmlContent == null
//           ? const Center(child: CircularProgressIndicator())
//           : WebViewWidget(controller: _controller),
//     );
//   }
// }
