import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nilaknaw/helper/project_helper.dart';
import 'package:nilaknaw/helper/project_list.dart';
import 'package:nilaknaw/helper/scroll_motion.dart';
import 'package:nilaknaw/pages/projects.dart';

class _NotesBundle extends CachingAssetBundle {
  int reads = 0;
  bool fail = false;

  @override
  Future<ByteData> load(String key) => rootBundle.load(key);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (!key.endsWith('.md')) return super.loadString(key, cache: cache);
    reads++;
    if (fail) throw StateError('Unavailable');
    return '# Project notes\n\nReadable **markdown** with a [link](https://example.com).\n\n'
        '| Parameter | Value |\n| --- | --- |\n| Gain | 71 dB |\n\n'
        'Inline math: \\(x^2\\).\n\n## Results\n\nThe project works.';
  }
}

void main() {
  testWidgets('opens within Projects and restores grid position on return',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bundle = _NotesBundle();
    final router = GoRouter(initialLocation: '/projects', routes: [
      GoRoute(
          path: '/projects',
          builder: (context, state) => Scaffold(
                appBar: AppBar(title: const Text('Portfolio navigation')),
                body: SmoothScroll(
                    child: ProjectsTab(
                        selectedAsset: state.uri.queryParameters['project'])),
              )),
    ]);
    addTearDown(router.dispose);
    await tester.pumpWidget(DefaultAssetBundle(
        bundle: bundle, child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();
    final grid = find.byKey(const PageStorageKey('projects-grid'));
    ScrollPosition gridPosition() => tester
        .state<ScrollableState>(
            find.descendant(of: grid, matching: find.byType(Scrollable)))
        .position;
    gridPosition().jumpTo(160);
    await tester.pump();
    final offset = gridPosition().pixels;
    await tester.tap(find.text(projects[4].title));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectReader), findsOneWidget);
    expect(find.byType(ProjectDetailPage), findsNothing);
    expect(find.text('Portfolio navigation'), findsOneWidget);
    expect(find.textContaining('Project notes', findRichText: true),
        findsOneWidget);
    expect(router.routeInformationProvider.value.uri.queryParameters['project'],
        projects[4].markdownAssetPath);
    expect(bundle.reads, 1);
    await tester.tap(find.text('All projects'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectReader), findsNothing);
    expect(gridPosition().pixels, offset);
    // Deep links also open the reader without needing to tap a tile first.
    router.go(Uri(path: '/projects', queryParameters: {
      'project': projects.first.markdownAssetPath,
    }).toString());
    await tester.pumpAndSettle();
    expect(find.byType(ProjectReader), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader fits mobile, survives rebuilds and retries failed loads',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bundle = _NotesBundle()..fail = true;
    await tester.pumpWidget(DefaultAssetBundle(
      bundle: bundle,
      child: MaterialApp(
          home: Scaffold(
              body:
                  SmoothScroll(child: ProjectReader(project: projects.first)))),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Could not load these notes.'), findsOneWidget);
    bundle.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Project notes', findRichText: true),
        findsOneWidget);
    expect(bundle.reads, 2);
    tester.view.physicalSize = const Size(800, 900);
    await tester.pumpAndSettle();
    expect(bundle.reads, 2);
    expect(tester.takeException(), isNull);
  });
}
