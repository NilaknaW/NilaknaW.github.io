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
              """Electronics and Telecommunication Engineering undergraduate at the University of Moratuwa 
with a strong academic record (GPA 3.95/4.0) and a passion for problem-solving through innovative hardware and software solutions. 
Interested in digital design, analog electronics, hardware acceleratio, and embedded systems. 
Also an accomplished hockey player and an orchestral musician.""",
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              )),
          AboutSectionCard(
              title: "👨‍🎓 Education",
              imagePath: "assets/images/uom.jpeg",
              description:
                  """I'm currently an undergraduate student in Electronic and Telecommunication Engineering at the University of Moratuwa. I actively contribute to both academic and extracurricular spheres—from hands-on electronics, robotics, and AI projects to leadership roles in clubs and societies. I’ve led and participated in national-level competitions, collaborative tech innovations, and organizational committees that bring students together around shared passions."""),
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
                "Playing as an attacker in my school and university hockey teams taught me teamwork, discipline, and resilience under pressure. I'm a proud representative of the Sri Lanka Universities Hockey Team, having competed at the Junior National Hockey Championship in both 2023 and 2024. I also played for the University of Moratuwa at the Sri Lanka University Games (2023) and Inter-University Games (2024), earning University Colors in 2023 and 2024 for my outstanding performance and commitment to the sport.",
            reverse: true,
          ),

          // Add more sections similarly
        ],
      ),
    );
  }
}
