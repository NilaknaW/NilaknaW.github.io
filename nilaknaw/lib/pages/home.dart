// === Home Tab ===
import 'package:flutter/material.dart';
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
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          // === Hero Section ===
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.95),
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 700;
                final leftContent = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isWide
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment:
                          isWide ? Alignment.centerLeft : Alignment.center,
                      child: AnimatedTextKit(
                        repeatForever: true,
                        pause: const Duration(milliseconds: 2000),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Hello, I am Nilakna.',
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'I am an Electronic and Telecommunication Engineering undergraduate interested in optoelectronics, analog and mixed-signal circuits, IC design, sensing, and experimental instrumentation. I enjoy working at the intersection of physics and electronics.',
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
                          label: const Text('View Resume'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Scrollable.ensureVisible(
                              _contactKey.currentContext!,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.mail),
                          label: const Text('Contact Me'),
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
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: isWide ? height * 0.8 : 0,
                  ),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Text
                      if (isWide) Expanded(child: leftContent) else leftContent,
                      SizedBox(width: isWide ? 40 : 0, height: isWide ? 0 : 40),
                      // Right: Image
                      if (isWide)
                        const Expanded(child: rightContent)
                      else
                        rightContent,
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),

          // // === Featured Section ===
          // Container(
          //   // height: height,
          //   padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          //   width: double.infinity,
          //   color: Colors.white,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text('Project Highlights',
          //           style: Theme.of(context).textTheme.headlineMedium),
          //       const SizedBox(height: 20),
          //       _highlights(context),
          //     ],
          //   ),
          // ),
          // const Divider(),

          // === Experience Section ===
          Container(
            // height: height,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Experience',
                    style: Theme.of(context).textTheme.headlineMedium),
                // const SizedBox(height: 20),
                AboutSectionCard(
                  title: "Research Assistant - Monash University",
                  imagePath: "assets/images/monash.jpg",
                  borderColor: Colors.teal.shade50,
                  description:
                      "Full time. Dec 2025 - May 2026\nResearch Assistant at the Exertion Games Lab,Monash University, Australia. Contributed to multiple projects in the lab- human-food interaction, Radarfoot, Vibrobits, and kids bodily extensions. Coauthored paper at CHI 2026 interactivity ACM.",
                ),
                AboutSectionCard(
                  title: "Intern - SLT Mobitel",
                  imagePath: "assets/images/sltm1.jpeg",
                  borderColor: Colors.teal.shade50,
                  description:
                      "Full time. Oct 2023 - Jan 2024\nEngineering Intern at SLT Mobitel, Network Planning and Operations Division. Worked on network optimization projects and embedded systems, including realtime license plate recognition system with computer vision.",
                ),
                AboutSectionCard(
                  title: "Intern - World Wildlife Fund (WWF)",
                  imagePath: "assets/images/wwf1.jpeg",
                  borderColor: Colors.teal.shade50,
                  description:
                      "Part time. Mar 2023 - Mar 2025\nIntern at WWF, Environmental and Disaster Management Division, under supervision of Dr. Missaka Hettiarachchi. Working on Augmented Reality mobile app for nature-based flood management method demonstration.",
                ),
              ],
            ),
          ),
          const Divider(),

          // === Interests & Skills Section ===
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 700;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Interests & Skills',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),

                    // 🔬 Research Interests — Topic left, chips right
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left: Contact Info
                              Expanded(
                                child: Text(
                                  '🔬 Research & Technical Interests',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 40),
                              // Right: Contact Form
                              Expanded(child: _buildInterestCard()),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🔬 Research & Technical Interests',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 30),
                              _buildInterestCard(),
                            ],
                          ),
                    const SizedBox(height: 24),
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _buildSkillCard()),
                              const SizedBox(width: 40),
                              Expanded(
                                child: Text('🛠️ Tools & Skills',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🛠️ Tools & Skills',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 30),
                              _buildSkillCard(),
                            ],
                          ),
                  ],
                );
              },
            ),
          ),
          const Divider(),

          // === Current Projects Section ===

          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Current Projects',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 30),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildCurrentProjectCard(
                      context,
                      title:
                          'Quantum-based ELF Magnetometer for Drone Detection and Classification',
                      subtitle: 'Project | Electronics | Quantum Physics',
                      description:
                          'Developing a quantum magnetometer. Focusing on designing low-noise, high-sensitivity optical frontend electronics and quantum sensing techniques.',
                    ),
                    _buildCurrentProjectCard(
                      context,
                      title:
                          'TasteLoop: Exploring Closed-Loop Digital Taste for Affective Modulation',
                      subtitle:
                          'Research | System Design | Human-Computer Interaction',
                      description:
                          'Developing a closed-loop system that adapts electrical tongue stimulation to short-term affective changes by physiological sensing.',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // === Competitions & Awards Section ===
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            width: double.infinity,
            // color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Competitions & Awards',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 30),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildAwardCard(
                      imagePath: 'assets/images/achievements/chi2.jpeg',
                      title: 'CHI 2026 Interactivity Demonstration Paper',
                      placement: 'Honorable Mention',
                      field: 'Human-Computer Interaction',
                      year: '2026',
                    ),
                    _buildAwardCard(
                      imagePath: 'assets/images/achievements/opampwin.jpg',
                      title: 'Analog IC Student Design Contest',
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
                      title: 'Sri Lanka Robotics Challenge (SLRC)',
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
                      title: 'IEEE EMBS Brainstorm Healthcare Challenge',
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
                      title: 'Silicon Pulse Analog Design Competition',
                      placement: 'Finalist',
                      field: 'Analog Design',
                      year: '2024',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // === Quick Contact Section ===
          Container(
            key: _contactKey,
            padding: const EdgeInsets.all(32),
            color: Colors.grey.shade100,
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
                              Expanded(child: _buildContactForm(context)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildContactInfo(context),
                              const SizedBox(height: 30),
                              _buildContactForm(context),
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
  }

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
          side: BorderSide(color: Colors.teal.shade50, width: 2),
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
          side: BorderSide(color: Colors.white, width: 2),
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

  Widget _buildSkillCard() {
    return const Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        Chip(
          avatar: Icon(Icons.memory, size: 16),
          label: Text('KLayout/Magic'),
        ),
        Chip(
          avatar: Icon(Icons.memory, size: 16),
          label: Text('SKY130 PDK'),
        ),
        Chip(
          avatar: Icon(Icons.code, size: 16),
          label: Text('SystemVerilog'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.amd),
          label: Text('Vivado'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.intel),
          label: Text('Quartus'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.cplusplus),
          label: Text('C++'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.python),
          label: Text('Python'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.ltspice, size: 16),
          label: Text('LTSpice'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.altiumdesigner, size: 16),
          label: Text('Altium'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.dassaultsystemes, size: 16),
          label: Text('SolidWorks'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.unity, size: 16),
          label: Text('Unity'),
        ),
        // Chip(
        //   avatar: Icon(SimpleIcons.espressif),
        //   label: Text('ESP32'),
        // ),
        // Chip(
        //   avatar: Icon(SimpleIcons.raspberrypi),
        //   label: Text('Raspberry Pi'),
        // ),
        Chip(
          avatar: Icon(SimpleIcons.ubuntu, size: 16),
          label: Text('Ubuntu'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.git, size: 16),
          label: Text('Git'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.flutter, size: 16),
          label: Text('Flutter'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.android, size: 16),
          label: Text('Android'),
        ),
        Chip(
          avatar: Icon(SimpleIcons.firebase, size: 16),
          label: Text('Firebase'),
        ),
      ],
    );
  }

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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Widget _buildContactForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Contact',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: 'Your Name',
                labelStyle: TextStyle(color: Colors.grey)),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'Your Email',
                labelStyle: TextStyle(color: Colors.grey)),
          ),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
                labelText: 'Message',
                labelStyle: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              final name = _nameController.text;
              final email = _emailController.text;
              final message = _messageController.text;

              final uri = Uri.parse(
                'https://formsubmit.io/send/nilawarush@gmail.com?name=$name&email=$email&message=$message',
              );

              launchUrl(uri);
            },
            icon: const Icon(Icons.send),
            label: const Text('Send'),
          ),
        ],
      ),
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
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal.shade50, width: 2),
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
