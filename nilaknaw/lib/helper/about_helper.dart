import 'package:flutter/material.dart';

class AboutSectionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final bool reverse;
  final Color borderColor;

  const AboutSectionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    this.reverse = false,
    this.borderColor = const Color(0xFFE0F2F1), // Colors.teal[50]
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 700;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection:
                isWide && reverse ? TextDirection.rtl : TextDirection.ltr,
            children: [
              // Image
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    height: isWide ? 200 : 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20, height: 20),
              // Text
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: isWide
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: isWide ? TextAlign.left : TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AboutProfileCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final bool reverse;
  final Color borderColor;

  const AboutProfileCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    this.reverse = false,
    this.borderColor = const Color(0xFFE0F2F1), // Colors.teal[50]
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 700;
      final image = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imagePath,
            width: double.infinity, height: 200, fit: BoxFit.cover),
      );
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.7)),
        ],
      );
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Expanded(child: image),
                  const SizedBox(width: 28),
                  Expanded(flex: 2, child: text),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [image, const SizedBox(height: 20), text],
              ),
      );
    });
  }
}
