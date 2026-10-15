// === Home Tab ===
import 'package:flutter/material.dart';
import '../helper/content_width.dart';
import '../helper/contact_form.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../helper/project_list.dart';
import '../helper/project_helper.dart';
// import '../helper/project_detail.dart';
import '../helper/about_helper.dart';

class HomeTab extends StatelessWidget {
  final String resumeUrl =
      'https://drive.google.com/drive/folders/1oGzpCXVH44Q9vQw64gb3kvY6HqsIWYXG?usp=drive_link'; // Replace this
  final GlobalKey _contactKey = GlobalKey();

  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, viewport) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // === Hero Section ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              margin: EdgeInsets.symmetric(
                  vertical: 24, horizontal: contentInset(context) + 24),
              // decoration: BoxDecoration(
              //   // color: Colors.white.withOpacity(0.95),
              //   border: Border.all(color: Colors.teal.shade50, width: 2),
              //   borderRadius: BorderRadius.circular(8),
              // ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 700;
                  final leftContent = Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      // Align(
                      //   alignment:
                      //       isWide ? Alignment.centerLeft : Alignment.center,
                      //   child: AnimatedTextKit(
                      //     repeatForever: true,
                      //     pause: const Duration(milliseconds: 2000),
                      //     animatedTexts: [
                      //       TypewriterAnimatedText(
                      //         'Hello, I am Nilakna.',
                      //         textStyle:
                      //             Theme.of(context).textTheme.headlineMedium,
                      //         speed: const Duration(milliseconds: 100),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      Text(
                        'I am Nilakna,',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'an Electronic and Telecommunication Engineering undergraduate interested in analog and mixed-signal circuits, IC design, optoelectronics, sensing, and experimental instrumentation. I enjoy working at the intersection of physics and electronics.',
                        style: const TextStyle(fontSize: 18),
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment:
                            isWide ? WrapAlignment.start : WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (await canLaunch(resumeUrl)) {
                                await launch(resumeUrl);
                              }
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Resume'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Scrollable.ensureVisible(
                                _contactKey.currentContext!,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.mail),
                            label: const Text('Contact'),
                          ),
                        ],
                      ),
                    ],
                  );
                  const rightContent = Center(
                    child: CircleAvatar(
                      radius: 220,
                      backgroundImage: AssetImage('assets/images/chi1.png'),
                    ),
                  );
                  final introduction = Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Text
                      if (isWide)
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: (constraints.maxWidth - 40) / 2,
                              child: leftContent,
                            ),
                          ),
                        )
                      else
                        leftContent,
                      SizedBox(width: isWide ? 40 : 0, height: isWide ? 0 : 40),
                      // Right: Image
                      if (isWide)
                        const Expanded(child: rightContent)
                      else
                        rightContent,
                    ],
                  );
                  final hero = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isWide)
                        Expanded(child: introduction)
                      else
                        introduction,
                      const SizedBox(height: 24),
                      _buildHeroSkills(),
                      const SizedBox(height: 8),
                    ],
                  );
                  return isWide
                      ? SizedBox(
                          height: (viewport.maxHeight - 48)
                              .clamp(0.0, double.infinity),
                          child: hero,
                        )
                      : hero;
                },
              ),
            ),
            Divider(color: Colors.teal[50], thickness: 2.0),

            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 60, horizontal: contentInset(context) + 24),
              width: double.infinity,
              // color: Colors.teal.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Research',
                      style: Theme.of(context).textTheme.headlineLarge),
                  // const SizedBox(height: 28),
                  // Text('Research Interests',
                  //     style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 28),
                  _citation(
                    context,
                    'Analog/mixed-signal circuits, IC design, optoelectronics, and quantum-sensing.',
                  ),
                  // Text(
                  //     'Analog circuit/IC design, optoelectronics, embedded systems, FPGA, quantum sensing.',
                  //     style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 28),
                  Text('Current Projects',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _citation(
                    context,
                    '1. Quantum ELF Magnetometer for Drone Detection and Classification',
                  ),
                  _citation(
                    context,
                    '2. Closed-loop Affective Modulation (Human-Computer Interaction)',
                  ),
                  const SizedBox(height: 28),
                  Text('Publications',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _citation(
                    context,
                    '1. Fang, Z., Wang, H., Warushavithana, N., Madusanka, S., Deng, J., Chen, W., Elvitigala, D., Mueller, F. 2026. [The Wizard of Taste: Demonstrating Multisensory Eating with Electrical Taste and Bone-conduction Auditory Seasoning](https://doi.org/10.1145/3772363.3799379). CHI 2026. Interactivity. ACM. [Video](https://youtu.be/S8Q2H2pGOHM).',
                  ),
                  const SizedBox(height: 12),
                  _citation(
                    context,
                    '2. Pathirana R., Balasooriya P., Warushavithana, N., Ravishan N., Sabnis N., Mueller F., and Elvitigala D. 2026. [Demonstrating VibeCoP: Guiding Balance Exercises through a Center of Pressure encoded Vibrotactile Waistband](https://doi.org/10.1145/3801727.3844936). SportsHCI Companion 2026. ACM. (Accepted)',
                  ),
                ],
              ),
            ),
            Divider(color: Colors.teal[50], thickness: 2.0),

            // // === Experience Section ===
            // Container(
            //   // height: height,
            //   padding: EdgeInsets.symmetric(
            //       vertical: 60, horizontal: contentInset(context) + 24),
            //   width: double.infinity,
            //   color: Colors.white,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text('Experience',
            //           style: Theme.of(context).textTheme.headlineLarge),
            //       // const SizedBox(height: 20),
            //       AboutProfileCard(
            //         title: "Research Assistant - Monash University",
            //         imagePath: "assets/images/monash.jpg",
            //         borderColor: Colors.teal.shade50,
            //         description:
            //             "Full time. Dec 2025 - May 2026\nResearch Assistant at the Exertion Games Lab, Monash University, Australia. Contributed to multiple projects in the lab- human-food interaction, Radarfoot, Vibrobits, and kids bodily extensions. Coauthored paper at ACM CHI 2026.",
            //       ),
            //       AboutProfileCard(
            //         title: "Intern - SLT Mobitel",
            //         imagePath: "assets/images/sltm1.jpeg",
            //         borderColor: Colors.teal.shade50,
            //         description:
            //             "Full time. Oct 2023 - Jan 2024\nEngineering Intern at SLT Mobitel, Network Planning and Operations Division. Worked on network optimization projects and embedded systems, including realtime license plate recognition system with computer vision.",
            //       ),
            //       AboutProfileCard(
            //         title: "Intern - World Wildlife Fund (WWF)",
            //         imagePath: "assets/images/wwf1.jpeg",
            //         borderColor: Colors.teal.shade50,
            //         description:
            //             "Part time. Mar 2023 - Mar 2025\nIntern at WWF, Environmental and Disaster Management Division, under supervision of Dr. Missaka Hettiarachchi. Working on Augmented Reality mobile app for nature-based flood management method demonstration.",
            //       ),
            //     ],
            //   ),
            // ),
            // const Divider(),

            // === Interests & Skills Section ===
            // Container(
            //   padding: EdgeInsets.symmetric(
            //       vertical: 60, horizontal: contentInset(context) + 24),
            //   width: double.infinity,
            //   color: Colors.teal.shade50,
            //   child: LayoutBuilder(
            //     builder: (context, constraints) {
            //       bool isWide = constraints.maxWidth > 700;
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Text('Interests & Skills',
            //               style: Theme.of(context).textTheme.headlineMedium),
            //           const SizedBox(height: 30),

            //           // 🔬 Research Interests — Topic left, chips right
            //           isWide
            //               ? Row(
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     // Left: Contact Info
            //                     Expanded(
            //                       child: Text(
            //                         '🔬 Research & Technical Interests',
            //                         style:
            //                             Theme.of(context).textTheme.titleLarge,
            //                         textAlign: TextAlign.right,
            //                       ),
            //                     ),
            //                     const SizedBox(width: 40),
            //                     // Right: Contact Form
            //                     Expanded(child: _buildInterestCard()),
            //                   ],
            //                 )
            //               : Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       '🔬 Research & Technical Interests',
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                     const SizedBox(height: 30),
            //                     _buildInterestCard(),
            //                   ],
            //                 ),
            //           const SizedBox(height: 24),
            //           isWide
            //               ? Row(
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Expanded(child: _buildSkillCard()),
            //                     const SizedBox(width: 40),
            //                     Expanded(
            //                       child: Text('🛠️ Tools & Skills',
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .titleLarge),
            //                     ),
            //                   ],
            //                 )
            //               : Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text('🛠️ Tools & Skills',
            //                         style:
            //                             Theme.of(context).textTheme.titleLarge),
            //                     const SizedBox(height: 30),
            //                     _buildSkillCard(),
            //                   ],
            //                 ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            // const Divider(),

            // === Bio Section ===

            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 60, horizontal: contentInset(context) + 24),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Me',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  Text(
                    """Hello, I am Nilakna. I love electronics, physics, and simply, creating things. This is why I like doing engineering research, as it brings two of my favorite things together: electronics and creativity. I like working in collaborative research teams, and I've been fortunate to work with some amazing researchers.

I also love music and sports. I play the clarinet in local orchestras and played for my university hockey team. I believe this diverse set of interests has helped me develop a unique thinking pattern. What I want to do is to be a researcher to help advance human knowledge through cutting-edge technologies.""",
                    textAlign: TextAlign.start,
                    // style: TextStyle(
                    //   fontSize: 18,
                    //   height: 1.7,
                    //   color: Colors.black54,
                    // ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Text('Experience',
                      style: Theme.of(context).textTheme.headlineSmall),
                  AboutProfileCard(
                    title: "Research Assistant - Monash University",
                    imagePath: "assets/images/monash.jpg",
                    borderColor: Colors.teal.shade50,
                    description:
                        "Full time. Dec 2025 - May 2026\nResearch Assistant at the Exertion Games Lab, Monash University, Australia. Contributed to multiple projects in the lab- human-food interaction, Radarfoot, Vibrobits, and kids bodily extensions. Coauthored paper at ACM CHI 2026.",
                  ),
                  AboutProfileCard(
                    title: "Intern - SLT Mobitel",
                    imagePath: "assets/images/sltm1.jpeg",
                    borderColor: Colors.teal.shade50,
                    description:
                        "Full time. Oct 2023 - Jan 2024\nEngineering Intern at SLT Mobitel, Network Planning and Operations Division. Worked on network optimization projects and embedded systems, including realtime license plate recognition system with computer vision.",
                    reverse: true,
                  ),
                  AboutProfileCard(
                    title: "Intern - World Wildlife Fund (WWF)",
                    imagePath: "assets/images/wwf1.jpeg",
                    borderColor: Colors.teal.shade50,
                    description:
                        "Part time. Mar 2023 - Mar 2025\nIntern at WWF, Environmental and Disaster Management Division, under supervision of Dr. Missaka Hettiarachchi. Working on Augmented Reality mobile app for nature-based flood management method demonstration.",
                  ),

                  const SizedBox(height: 32),
                  Text('Education & Leadership',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const AboutProfileCard(
                      title: "👨‍🎓 Undergraduate",
                      imagePath: "assets/images/uom.jpeg",
                      description:
                          """I'm currently an undergraduate student in Electronic and Telecommunication Engineering at the University of Moratuwa, with a strong academic record (CGPA: 3.94/4.00) and a passion for engineering research. I actively contribute to both academic and extracurricular work from hands-on electronics projects to leadership roles in clubs and societies. I serve as the head of web in Electronics Club and was the president of the Mathematics Society."""),
                  const AboutProfileCard(
                    title: "🏫 School Journey",
                    imagePath: "assets/images/school.JPG",
                    description:
                        """My foundation was laid at Visakha Vidyalaya, where I first developed a deep interest in both science and the arts. I was actively involved in prefects guilds, school band, hockey and montaineering teams, and societies. I served as the School Head Prefect and graduated with a strong academic and leadership record.""",
                    reverse: true,
                  ),
                  const SizedBox(height: 32),
                  Text('Beyond Research',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const AboutProfileCard(
                    title: "🎵 Music",
                    imagePath: "assets/images/music4.jpeg",
                    description:
                        "Music has always been a big part of my life. As an instrumentalist, I've found a second voice through music. I play the clarinet in the Colombo Wind Orchestra and the Junior Symphony Orchestra, and I regularly perform for university events. My musical talents extend to the piano, drums, and violin, and I've also composed a few original pieces as I explore music. Music has been not just a passion but a way to express creativity and build community through performance.",
                  ),
                  const AboutProfileCard(
                    title: "🏑 Hockey",
                    imagePath: "assets/images/hockey.jpeg",
                    description:
                        "Playing as an attacker in my school and university hockey teams taught me teamwork, discipline, and resilience under pressure. I'm a proud representative of the Sri Lanka Universities Hockey Team, having competed at the Junior National Hockey Championship in both 2023 and 2024. I also played for the University of Moratuwa at the Sri Lanka University Games and Inter-University Games, earning University Colors in 2023, 2024, and 2025, for my performance and commitment to the sport.",
                    reverse: true,
                  ),

                  // Add more sections similarly
                ],
              ),
            ),

            // === Quick Contact Section ===
            Container(
              key: _contactKey,
              padding: EdgeInsets.symmetric(
                  vertical: 32, horizontal: contentInset(context) + 32),
              color: Colors.teal[50],
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 700;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Contact Info
                                Expanded(child: _buildContactInfo(context)),
                                const SizedBox(width: 40),
                                // Right: Contact Form
                                Expanded(child: const ContactForm()),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildContactInfo(context),
                                const SizedBox(height: 30),
                                const ContactForm(),
                              ],
                            ),
                      const SizedBox(height: 40),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 10),
                      // Text(
                      //   'Nilakna Warushavithana 2025',
                      //   style: TextStyle(fontSize: 14, color: Colors.grey),
                      //   textAlign: TextAlign.center,
                      // ),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Made with '),
                            WidgetSpan(
                              child: Icon(Icons.favorite,
                                  color: Colors.red, size: 16),
                            ),
                            TextSpan(text: ' by Nilakna Warushavithana. 2025.'),
                          ],
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _citation(BuildContext context, String text) => MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          a: TextStyle(
              color: Colors.teal.shade900,
              decoration: TextDecoration.underline),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href), webOnlyWindowName: '_blank');
          }
        },
      );

  Widget _buildCurrentProjectCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String description}) {
    return SizedBox(
      width: 300,
      child: Card.outlined(
        // elevation: 3,color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: Colors.teal, fontSize: 13)),
              SizedBox(height: 12),
              Text(description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
            ],
          ),
        ),
      ),
    );
  }

  static const _tools = [
    (icon: Icons.memory, label: 'KLayout/Magic'),
    (icon: Icons.memory, label: 'SKY130 PDK'),
    (icon: Icons.code, label: 'SystemVerilog'),
    (icon: SimpleIcons.amd, label: 'Vivado'),
    (icon: SimpleIcons.intel, label: 'Quartus'),
    (icon: SimpleIcons.cplusplus, label: 'C++'),
    (icon: SimpleIcons.python, label: 'Python'),
    (icon: SimpleIcons.ltspice, label: 'LTSpice'),
    (icon: SimpleIcons.altiumdesigner, label: 'Altium'),
    (icon: SimpleIcons.dassaultsystemes, label: 'SolidWorks'),
    (icon: SimpleIcons.unity, label: 'Unity'),
    (icon: SimpleIcons.ubuntu, label: 'Ubuntu'),
    (icon: SimpleIcons.git, label: 'Git'),
    (icon: SimpleIcons.flutter, label: 'Flutter'),
    (icon: SimpleIcons.android, label: 'Android'),
    (icon: SimpleIcons.firebase, label: 'Firebase'),
  ];

  Widget _buildHeroSkills() => Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tool in _tools)
              Tooltip(
                message: tool.label,
                waitDuration: const Duration(milliseconds: 150),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(tool.icon, size: 24, color: Colors.teal.shade800),
                ),
              ),
          ],
        ),
      );

  Widget _buildSkillCard() => Wrap(
        alignment: WrapAlignment.end,
        spacing: 12,
        runSpacing: 8,
        children: [
          for (final tool in _tools)
            Chip(avatar: Icon(tool.icon, size: 16), label: Text(tool.label)),
        ],
      );

  Widget _buildInterestCard() {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        Chip(label: Text('Analog Circuit Design')),
        Chip(label: Text('Optoelectronics')),
        Chip(label: Text('Analog IC Design')),
        Chip(label: Text('FPGA')),
        Chip(label: Text('Embedded Systems')),
        Chip(label: Text('Sensor Development')),
        Chip(label: Text('Human-Computer Interaction')),
        Chip(label: Text('Quantum Sensing')),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reach Out', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(
            'warushavithanand.22@uom.lk',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () =>
              launchUrl(Uri.parse('mailto:warushavithanand.22@uom.lk')),
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('GitHub'),
          subtitle: Text(
            'github.com/NilaknaW',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () => launchUrl(Uri.parse('https://github.com/NilaknaW')),
        ),
        ListTile(
          leading: const Icon(Icons.business),
          title: const Text('LinkedIn'),
          subtitle: Text(
            'linkedin.com/in/nilakna-warushavithana',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () => launchUrl(
              Uri.parse('https://linkedin.com/in/nilakna-warushavithana')),
        ),
        ListTile(
          leading: const Icon(Icons.assignment_ind_sharp),
          title: const Text('ORCID id'),
          subtitle: Text(
            'orcid.org/0009-0009-7133-2022',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () =>
              launchUrl(Uri.parse('https://orcid.org/0009-0009-7133-2022')),
        ),
      ],
    );
  }

  Widget _highlights(
    BuildContext context,
  ) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        for (var project in highlights) _highlightCard(context, project),
      ],
    );
  }

  Widget _highlightCard(BuildContext context, Project project) {
    return Card(
      color: Colors.teal.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white, width: 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectDetailPage(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  project.imagePath,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                project.title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
