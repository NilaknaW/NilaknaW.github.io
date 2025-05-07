import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/projects.dart';
import 'pages/blog.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nilakna',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.teal[50],
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
            secondary: Colors.teal,
          ),
          textTheme: GoogleFonts.robotoSlabTextTheme()),
      home: const PortfolioHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = [
    const Tab(text: 'Home'),
    const Tab(text: 'About'),
    const Tab(text: 'Projects'),
    const Tab(text: 'Blog'),
  ];

  final List<Widget> tabViews = [
    HomeTab(),
    AboutTab(),
    ProjectsTab(),
    BlogTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: TextButton(
          onPressed: () {
            _tabController.animateTo(0); // Go to Home tab
          },
          child: const Text('Nilakna'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              SimpleIcons.github,
              size: 16,
              color: Colors.grey.shade600,
            ),
            onPressed: () =>
                launchUrl(Uri.parse('https://github.com/NilaknaW')),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/linkedin.svg',
              height: 16,
              width: 16,
              color: Colors.grey.shade600,
            ),
            onPressed: () => launchUrl(
                Uri.parse('https://linkedin.com/in/nilakna-warushavithana')),
          ),
          const SizedBox(width: 16),
        ],
        title: TabBar(
          controller: _tabController,
          isScrollable: true, // Responsive tabs
          tabs: myTabs,
          indicatorColor: Colors.grey,
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.transparent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabViews,
      ),
    );
  }
}
