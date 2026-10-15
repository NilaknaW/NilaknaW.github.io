import 'package:flutter/material.dart';
import 'content_width.dart';

class AwardsSection extends StatelessWidget {
  const AwardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 60, horizontal: contentInset(context) + 24),
      width: double.infinity,
      // color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Competition Achievements',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              // _buildAwardCard(
              //   imagePath: 'assets/images/achievements/chi2.jpeg',
              //   title: 'CHI 2026 Interactivity Demonstration Paper',
              //   placement: 'Honorable Mention',
              //   field: 'Human-Computer Interaction',
              //   year: '2026',
              // ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/opampwin.jpg',
                title: 'Analog IC Design Contest',
                placement: 'Second Place',
                field: 'Analog IC Design',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/dvcon.png',
                title: 'DVCon India Design Contest',
                placement: 'Finalist',
                field: 'FPGA / Digital Design',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/makeathon2.jpeg',
                title: 'Inter University Make-a-thon',
                placement: 'Winner',
                field: 'Medical Devices / 3D Design',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/slrc3.jpeg',
                title: 'Sri Lanka Robotics Challenge',
                placement: 'Finalist',
                field: 'Robotics',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/sliot1.jpeg',
                title: 'Sri Lanka IoT Challenge (SLIoT)',
                placement: 'Finalist',
                field: 'IoT / Embedded Systems',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/markdown/nutri.png',
                title: 'IEEE EMBS Brainstorm',
                placement: 'Finalist',
                field: 'Healthcare / Embedded Systems',
                year: '2025',
              ),
              _buildAwardCard(
                imagePath: 'assets/images/achievements/AIchallenge.jpeg',
                title: 'IEEE Sri Lanka AI Challenge',
                placement: 'Finalist',
                field: 'AI / Web Development',
                year: '2024',
              ),
              _buildAwardCard(
                imagePath: 'assets/markdown/siliconedge/sp5.jpeg',
                title: 'Silicon Pulse Design Contest',
                placement: 'Finalist',
                field: 'Analog Design',
                year: '2024',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard({
    required String imagePath,
    required String title,
    required String placement,
    required String field,
    required String year,
  }) {
    return SizedBox(
      width: 280,
      child: Card.outlined(
        // elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.teal.shade50, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(field,
                      style: TextStyle(color: Colors.teal, fontSize: 13)),
                  SizedBox(height: 12),
                  Text('$placement • $year',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
