import 'package:flutter/material.dart';
import 'blog_list.dart';
import 'project_list.dart';
import 'seo_stub.dart' if (dart.library.js_interop) 'seo_web.dart' as platform;

const siteName = 'Nilakna Warushavithana';
const siteOrigin = 'https://nilaknaw.github.io';
const profileDescription = 'Nilakna Warushavithana is an Electronic and '
    'Telecommunication Engineering undergraduate interested in analog and '
    'mixed-signal circuits, IC design, optoelectronics, sensing, and experimental instrumentation.';

class PageSeo extends StatefulWidget {
  const PageSeo(
      {super.key,
      required this.pageIndex,
      this.projectAsset,
      required this.child});
  final int pageIndex;
  final String? projectAsset;
  final Widget child;

  @override
  State<PageSeo> createState() => _PageSeoState();
}

class _PageSeoState extends State<PageSeo> {
  late String _title;

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void didUpdateWidget(PageSeo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex ||
        oldWidget.projectAsset != widget.projectAsset) {
      _update();
    }
  }

  void _update() {
    _title = siteName;
    var description = profileDescription;
    var path = '/';
    Map<String, String>? query;
    if (widget.pageIndex == 1) {
      path = '/projects';
      _title = 'Projects | $siteName';
      description =
          'Explore engineering projects, research articles and technical '
          'notes by Nilakna Warushavithana, from analog IC design to embedded systems and robotics.';
      for (final project in [...projects, ...blogs, ...articles]) {
        if (project.markdownAssetPath == widget.projectAsset) {
          _title = '${project.title} | $siteName';
          description =
              '${project.title}: project notes and technical details by $siteName.';
          query = {'project': project.markdownAssetPath};
          break;
        }
      }
    } else if (widget.pageIndex == 2) {
      path = '/resources';
      _title = 'Study Resources | $siteName';
      description =
          'Study resources and notes in physics, chemistry and music shared by Nilakna Warushavithana.';
    }
    final canonical = Uri.parse(siteOrigin)
        .replace(path: path, queryParameters: query)
        .toString();
    platform.updateSeo(_title, description, canonical);
  }

  @override
  Widget build(BuildContext context) =>
      Title(title: _title, color: Colors.teal, child: widget.child);
}
