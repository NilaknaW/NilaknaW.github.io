import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'helper/scroll_motion.dart';
import 'pages/home.dart';
import 'pages/projects.dart';
import 'pages/resources.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyPortfolioApp());
}

const pagePaths = ['/', '/projects', '/resources'];

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/blog', redirect: (context, state) => '/projects'),
      GoRoute(path: '/publications', redirect: (context, state) => '/'),
      GoRoute(path: '/about', redirect: (context, state) => '/'),
      for (var index = 0; index < pagePaths.length; index++)
        GoRoute(
          path: pagePaths[index],
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 450),
            reverseTransitionDuration: const Duration(milliseconds: 450),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              if (MediaQuery.disableAnimationsOf(context)) return child;
              return FadeTransition(
                opacity:
                    animation.drive(CurveTween(curve: Curves.easeInOutCubic)),
                child: child,
              );
            },
            child: PortfolioHomePage(pageIndex: index),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nilakna',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
            secondary: Colors.teal,
          ),
          textTheme: GoogleFonts.robotoSlabTextTheme()),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  PortfolioHomePage({super.key, this.pageIndex = 0});

  final int pageIndex;

  final List<Tab> myTabs = [
    const Tab(text: 'Home'),
    const Tab(text: 'Projects'),
    const Tab(text: 'Resources'),
  ];

  final List<Widget> tabViews = [
    HomeTab(),
    ProjectsTab(),
    ResourcesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: Image.asset('assets/images/favicon.png', height: 40),
          onPressed: () {
            // Handle menu button press
          },
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
        title: DefaultTabController(
          key: ValueKey(pageIndex),
          length: myTabs.length,
          initialIndex: pageIndex,
          child: TabBar(
            onTap: (index) => context.go(pagePaths[index]),
            isScrollable: true, // Responsive tabs
            tabs: myTabs,
            indicatorColor: Colors.grey,
            tabAlignment: TabAlignment.center,
            dividerColor: Colors.transparent,
          ),
        ),
      ),
      body: SmoothScroll(child: SizedBox.expand(child: tabViews[pageIndex])),
    );
  }
}
