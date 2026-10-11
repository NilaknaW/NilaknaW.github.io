// === About Tab ===
import 'package:flutter/material.dart';
// import '../helper/responsive.dart';
import '../helper/about_helper.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: const [
          Text(
//               """Electronics and Telecommunication Engineering undergraduate at the University of Moratuwa
// with a strong academic record (CGPA 3.94/4.0) and a passion for problem-solving through innovative hardware and software solutions.
// Interested in analog and digital design, hardware acceleratio, embedded systems, and human-computer interaction.
// Also an accomplished hockey player and an orchestral musician.""",
              """Hello, I am Nilakna. I love electronics, physics, and simply, creating things.
              This is why I like doing engineering research, as it brings two of my favorite things together: electronics and creativity.
              I like working in collaborative research teams, and I've been fortunate to work with some amazing researchers.
              I also love music and sports. I play the clarinet in local orchestras and played for my university hockey team.
              I believe this diverse set of interests has helped me develop a unique thinking pattern.
              What I want to do is to be a researcher to help advance human knowledge through cutting-edge technologies.""",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              )),
          AboutSectionCard(
              title: "👨‍🎓 Education",
              imagePath: "assets/images/uom.jpeg",
              description:
                  """I'm currently an undergraduate student in Electronic and Telecommunication Engineering at the University of Moratuwa, with a strong academic record (CGPA: 3.94/4.00) and a passion for engineering research. I actively contribute to both academic and extracurricular work from hands-on electronics projects to leadership roles in clubs and societies. I serve as the head of web in Electronics Club and was the president of the Mathematics Society."""),
          AboutSectionCard(
            title: "🏫 School Journey",
            imagePath: "assets/images/school.JPG",
            description:
                """My foundation was laid at Visakha Vidyalaya, where I first developed a deep interest in both science and the arts. I was actively involved in prefects guilds, school band, hockey and montaineering teams, and societies. I served as the School Head Prefect and graduated with a strong academic and leadership record.""",
            reverse: true,
          ),
          AboutSectionCard(
            title: "🎵 Music",
            imagePath: "assets/images/music4.jpeg",
            description:
                "Music has always been a big part of my life. As an instrumentalist, I've found a second voice through music. I play the clarinet in the Colombo Wind Orchestra and the Junior Symphony Orchestra, and I regularly perform for university events. My musical talents extend to the piano, drums, and violin, and I've also composed a few original pieces as I explore music. Music has been not just a passion but a way to express creativity and build community through performance.",
          ),
          AboutSectionCard(
            title: "🏑 Hockey",
            imagePath: "assets/images/hockey.jpeg",
            description:
                "Playing as an attacker in my school and university hockey teams taught me teamwork, discipline, and resilience under pressure. I'm a proud representative of the Sri Lanka Universities Hockey Team, having competed at the Junior National Hockey Championship in both 2023 and 2024. I also played for the University of Moratuwa at the Sri Lanka University Games and Inter-University Games, earning University Colors in 2023, 2024, and 2025, for my performance and commitment to the sport.",
            reverse: true,
          ),

          // Add more sections similarly
        ],
      ),
    );
  }
}
