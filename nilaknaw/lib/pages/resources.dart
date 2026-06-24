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
    _ResourceDocument(
      level: 'A-Level',
      subject: 'Physics',
      title: 'Physics Practicals',
      type: 'Notes',
      link:
          'https://drive.google.com/file/d/1AYD-uVkJWMignc06MQgOX1hwwi8MLayf/view?usp=drive_link',
      tags: ['practicals', 'experiments', 'observations'],
    ),
    _ResourceDocument(
      level: 'A-Level',
      subject: 'Chemistry',
      title: 'Inorganic Chemistry Summary',
      type: 'Short Notes',
      link:
          'https://drive.google.com/file/d/14UrO5AhcgztQELq6-UTqYAONv8O7qEMJ/view?usp=drive_link',
      tags: ['inorganic', 'reactions'],
    ),
    _ResourceDocument(
      level: 'A-Level',
      subject: 'Chemistry',
      title: 'Organic Chemistry Summary',
      type: 'Short Notes',
      link:
          'https://drive.google.com/file/d/16YElJOZ74eci4Lpmjfxtec7yctFw_-RK/view?usp=drive_link',
      tags: ['organic', 'reactions'],
    ),
    _ResourceDocument(
      level: 'Graded Exams',
      subject: 'Music',
      title: 'Music Theory Notes',
      type: 'Short Notes',
      link:
          'https://drive.google.com/file/d/10tFd39qZcu8lqKcxD9IXlWt-8nktIK8u/view?usp=drive_link',
      tags: ['music', 'theory'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDocuments = _documents.where(_matchesQuery).toList();
    final groupedDocuments = _groupDocuments(filteredDocuments);

    return SingleChildScrollView(
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
              'These are scanned notes I used to study for different exams. The notes are based on school, tuition, books, and lots of self-learning. These are strictly not intended for commercial use but merely for any student that needs them. Ensure you use them responsibly!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _PasswordAccessCard(),
          ),
          const SizedBox(height: 20),
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: filteredDocuments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('No resources found.')),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final group in groupedDocuments.entries) ...[
                        _ResourceSectionHeader(title: group.key),
                        for (final document in group.value)
                          _ResourceRow(document: document),
                      ],
                    ],
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

class _PasswordAccessCard extends StatefulWidget {
  @override
  State<_PasswordAccessCard> createState() => _PasswordAccessCardState();
}

class _PasswordAccessCardState extends State<_PasswordAccessCard> {
  static const String _documentPassword = 'student-resources';

  bool _hasAgreed = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Password',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Some documents may be password protected. Contact me to request access if you need them for personal studying or academic revision.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Text(
            'Terms and disclaimer',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'These resources are shared only for educational use. They must not be sold, repackaged, redistributed for profit, or used for any commercial purpose. By requesting the password, you agree to use them responsibly and give proper respect to the original material and sources.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const _MiniChip('Personal Study Only'),
              const _MiniChip('No Commercial Use'),
              const _MiniChip('Responsible Sharing'),
            ],
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _hasAgreed,
            onChanged: (value) {
              setState(() {
                _hasAgreed = value ?? false;
                if (!_hasAgreed) _showPassword = false;
              });
            },
            title: const Text(
              'I agree to use these documents only for personal study and not for commercial purposes.',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _hasAgreed
                    ? () => setState(() => _showPassword = true)
                    : null,
                icon: const Icon(Icons.lock_open),
                label: const Text('Agree and Show Password'),
              ),
              if (_showPassword)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(color: Colors.teal.shade100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SelectableText(
                    _documentPassword,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
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
