import 'package:flutter/material.dart';
import '../helper/content_width.dart';
import '../helper/project_helper.dart';
import '../helper/project_list.dart';
// import '../helper/project_detail.dart';

// === Projects Tab ===
class ProjectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth =
            constraints.maxWidth - 2 * (contentInset(context) + 24);
        int crossAxisCount = contentWidth > 900
            ? 4
            : contentWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          padding: EdgeInsets.symmetric(
              vertical: 24, horizontal: contentInset(context) + 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectTile(
              project: project,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailPage(project: project),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
