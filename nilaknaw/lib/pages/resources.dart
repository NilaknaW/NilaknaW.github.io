import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesTab extends StatefulWidget {
  const ResourcesTab({super.key});

  @override
  State<ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<ResourcesTab> {
  String _query = '';

  static const List<_ResourceDocument> _documents = [
    // _ResourceDocument(
    //   level: 'A-Level',
    //   subject: 'Physics',
    //   title: 'Mechanics Short Notes',
    //   type: 'Short Notes',
    //   link: 'https://example.com/a-level-physics-mechanics-short-notes.pdf',
    //   tags: ['mechanics', 'motion', 'forces'],
    // ),
    // _ResourceDocument(
    //   level: 'A-Level',
    //   subject: 'Physics',
    //   title: 'Electricity Past Paper Answers',
    //   type: 'Answer Sheet',
    //   link: 'https://example.com/a-level-physics-electricity-answers.pdf',
    //   tags: ['electricity', 'past papers'],
    // ),
    // _ResourceDocument(
    //   level: 'A-Level',
    //   subject: 'Combined Mathematics',
    //   title: 'Calculus Formula Sheet',
    //   type: 'Formula Sheet',
    //   link: 'https://example.com/a-level-combined-maths-calculus.pdf',
    //   tags: ['calculus', 'formulas'],
    // ),
    // _ResourceDocument(
    //   level: 'A-Level',
    //   subject: 'Chemistry',
    //   title: 'Organic Chemistry Summary',
    //   type: 'Short Notes',
    //   link: 'https://example.com/a-level-chemistry-organic-summary.pdf',
    //   tags: ['organic', 'reactions'],
    // ),
    // _ResourceDocument(
    //   level: 'O-Level',
    //   subject: 'Science',
    //   title: 'Electric Circuits Revision',
    //   type: 'Short Notes',
    //   link: 'https://example.com/o-level-science-electric-circuits.pdf',
    //   tags: ['circuits', 'revision'],
    // ),
    // _ResourceDocument(
    //   level: 'O-Level',
    //   subject: 'Mathematics',
    //   title: 'Geometry Model Answers',
    //   type: 'Answer Sheet',
    //   link: 'https://example.com/o-level-maths-geometry-answers.pdf',
    //   tags: ['geometry', 'answers'],
    // ),
    // _ResourceDocument(
    //   level: 'O-Level',
    //   subject: 'ICT',
    //   title: 'Database Systems Notes',
    //   type: 'Short Notes',
    //   link: 'https://example.com/o-level-ict-database-systems.pdf',
    //   tags: ['database', 'ict'],
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDocuments = _documents.where(_matchesQuery).toList();
    final groupedDocuments = _groupDocuments(filteredDocuments);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Resources',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Text(
              'Scanned A-Level and O-Level notes, short notes, answer sheets, and revision documents.\nComing Soon...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by subject, topic, type, or level',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${filteredDocuments.length} documents',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: filteredDocuments.isEmpty
                  ? const Center(child: Text('No resources found.'))
                  : ListView(
                      children: [
                        for (final group in groupedDocuments.entries) ...[
                          _ResourceSectionHeader(title: group.key),
                          for (final document in group.value)
                            _ResourceRow(document: document),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _matchesQuery(_ResourceDocument document) {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return true;

    final searchableText = [
      document.level,
      document.subject,
      document.title,
      document.type,
      ...document.tags,
    ].join(' ').toLowerCase();

    return searchableText.contains(normalizedQuery);
  }

  Map<String, List<_ResourceDocument>> _groupDocuments(
      List<_ResourceDocument> documents) {
    final grouped = <String, List<_ResourceDocument>>{};
    for (final document in documents) {
      final key = '${document.level} / ${document.subject}';
      grouped.putIfAbsent(key, () => []).add(document);
    }
    return grouped;
  }
}

class _ResourceDocument {
  final String level;
  final String subject;
  final String title;
  final String type;
  final String link;
  final List<String> tags;

  const _ResourceDocument({
    required this.level,
    required this.subject,
    required this.title,
    required this.type,
    required this.link,
    required this.tags,
  });
}

class _ResourceSectionHeader extends StatelessWidget {
  final String title;

  const _ResourceSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  final _ResourceDocument document;

  const _ResourceRow({required this.document});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(document.link),
          webOnlyWindowName: '_blank',
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 640;
              final title = Text(
                document.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              );
              final metadata = Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _MiniChip(document.type),
                  for (final tag in document.tags.take(2)) _MiniChip(tag),
                ],
              );

              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 8),
                    metadata,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 3, child: title),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: metadata),
                  const SizedBox(width: 8),
                  Icon(Icons.open_in_new,
                      size: 16, color: Colors.grey.shade600),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: Colors.grey.shade300),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
