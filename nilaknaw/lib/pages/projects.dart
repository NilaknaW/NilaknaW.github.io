import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../helper/content_width.dart';
import '../helper/awards_section.dart';
import '../helper/project_helper.dart';
import '../helper/project_list.dart';
import '../helper/blog_list.dart';
import '../helper/scroll_motion.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key, this.selectedAsset});

  final String? selectedAsset;

  @override
  Widget build(BuildContext context) {
    Project? selected;
    for (final project in [...projects, ...blogs, ...articles]) {
      if (project.markdownAssetPath == selectedAsset) selected = project;
    }
    final activeProject = selected;
    return SizedBox.expand(
        child: Stack(
      children: [
        Offstage(
          offstage: activeProject != null,
          child: TickerMode(
            enabled: activeProject == null,
            child: _buildGrid(context),
          ),
        ),
        if (activeProject != null)
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.go('/projects'),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('All projects'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(activeProject.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SmoothScroll(
                    key: ValueKey(activeProject.markdownAssetPath),
                    child: ProjectReader(project: activeProject),
                  ),
                ),
              ],
            ),
          ),
      ],
    ));
  }

  Widget _buildGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final inset = contentInset(context) + 24;
        final contentWidth = constraints.maxWidth - 2 * inset;
        final crossAxisCount = contentWidth > 900
            ? 4
            : contentWidth > 600
                ? 2
                : 1;

        return CustomScrollView(
          key: const PageStorageKey('projects-grid'),
          primary: true,
          slivers: [
            for (final section in [
              (title: 'Projects', items: projects, spacing: 24.0),
              (title: 'Posts', items: blogs, spacing: 16.0),
              (title: 'Articles', items: articles, spacing: 16.0),
            ]) ...[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(inset, 24, inset, 12),
                sliver: SliverToBoxAdapter(
                  child: Text(section.title,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(inset, 0, inset, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: section.spacing,
                    mainAxisSpacing: section.spacing,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = section.items[index];
                      return ProjectTile(
                        project: project,
                        onTap: () => context.go(Uri(
                          path: '/projects',
                          queryParameters: {
                            'project': project.markdownAssetPath
                          },
                        ).toString()),
                      );
                    },
                    childCount: section.items.length,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: AwardsSection()),
          ],
        );
      },
    );
  }
}
