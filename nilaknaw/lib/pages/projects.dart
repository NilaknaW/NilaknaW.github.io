import 'package:flutter/material.dart';
import '../helper/content_width.dart';
import '../helper/awards_section.dart';
import '../helper/project_helper.dart';
import '../helper/project_list.dart';
import '../helper/blog_list.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailPage(project: project),
                          ),
                        ),
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
