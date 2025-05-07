import 'package:flutter/material.dart';

class AboutSectionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final bool reverse;

  const AboutSectionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 700;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
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
