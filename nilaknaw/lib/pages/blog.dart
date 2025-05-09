import 'package:flutter/material.dart';
import '../helper/blog_list.dart';
import '../helper/project_helper.dart';
// import '../helper/project_detail.dart';

// === Blog Tab ===
class BlogTab extends StatelessWidget {
  const BlogTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 900
              ? 4
              : constraints.maxWidth > 600
                  ? 2
                  : 1;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final project = blogs[index];
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
      ),
    );
  }
}
