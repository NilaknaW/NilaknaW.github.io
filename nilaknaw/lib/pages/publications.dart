import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationsTab extends StatelessWidget {
  const PublicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Publications',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          const _PublicationListItem(
            label: 'CHI 2026',
            title:
                'The Wizard of Taste: Demonstrating Multisensory Eating with Electrical Taste and Bone-conduction Auditory Seasoning',
            authors:
                "Ziqi Fang, Hongyue Wang, Nilakna Disiwari Warushavithana, Subasinghe Piyarathnage Sahan Madusanka, Jialin Deng, Weijen Chen, Don Samitha Elvitigala, and Florian 'Floyd' Mueller",
            venue:
                '2026 CHI Conference on Human Factors in Computing Systems. Barcelona, Spain. \nHonorouble Mention for Interactivity Paper.',
            details: 'ACM, pp. 1-5. DOI: 10.1145/3772363.3799379',
            keywords: [
              'Human-Computer Interaction',
              'Embedded Systems',
            ],
            link: 'https://dl.acm.org/doi/10.1145/3772363.3799379',
            conferenceLink: 'https://nilaknaw.github.io/chi/',
          ),
          const _PublicationListItem(
            label: 'MERCon',
            title:
                '1-Bit Reconfigurable Intelligent Surface Design and Indoor Beam-Steering Validation at 2.4 GHz',
            authors:
                "Nilakna Disiwari Warushavithana, Sampath Edirisinghege, Dulika Rukshan Nayanasiri, and Samiru Gayan",
            venue: 'MERCon 2026 (Accepted). Colombo, Sri Lanka',
            details: '',
            keywords: [
              'Communication',
              'Wireless Systems',
              'Beam Steering',
            ],
          ),
        ],
      ),
    );
  }
}

class _PublicationListItem extends StatelessWidget {
  final String label;
  final String title;
  final String authors;
  final String venue;
  final String details;
  final List<String> keywords;
  final String? link;
  final String? conferenceLink;

  const _PublicationListItem({
    required this.label,
    required this.title,
    required this.authors,
    required this.venue,
    required this.details,
    required this.keywords,
    this.link,
    this.conferenceLink,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;
            final labelWidget = SizedBox(
              width: isWide ? 130 : double.infinity,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(authors, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  venue,
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                const SizedBox(height: 6),
                Text(
                  details,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final keyword in keywords) _KeywordChip(keyword),
                    if (link != null)
                      ActionChip(
                        avatar: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('View Paper'),
                        onPressed: () => launchUrl(
                          Uri.parse(link!),
                          webOnlyWindowName: '_blank',
                        ),
                      ),
                    if (conferenceLink != null)
                      ActionChip(
                        avatar: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('More Info'),
                        onPressed: () => launchUrl(
                          Uri.parse(conferenceLink!),
                          webOnlyWindowName: '_blank',
                        ),
                      ),
                  ],
                ),
              ],
            );

            if (!isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWidget,
                  const SizedBox(height: 10),
                  content,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                const SizedBox(width: 24),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;

  const _KeywordChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey.shade200,
      side: BorderSide(color: Colors.grey.shade300),
      label: Text(label),
    );
  }
}
