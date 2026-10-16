import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SmoothScroll extends StatefulWidget {
  const SmoothScroll({super.key, required this.child});
  final Widget child;

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  final _controller = _WheelController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reduceMotion = MediaQuery.disableAnimationsOf(context);
    return PrimaryScrollController(
        controller: _controller, child: widget.child);
  }
}

class _WheelController extends ScrollController {
  bool reduceMotion = false;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
          ScrollContext context, ScrollPosition? oldPosition) =>
      _WheelPosition(
        physics: physics,
        context: context,
        oldPosition: oldPosition,
        reduceMotion: () => reduceMotion,
      );
}

class _WheelPosition extends ScrollPositionWithSingleContext {
  _WheelPosition(
      {required super.physics,
      required super.context,
      super.oldPosition,
      required this.reduceMotion});
  final bool Function() reduceMotion;
  double? _target;
  int _generation = 0;

  @override
  void pointerScroll(double delta) {
    if (reduceMotion() || delta == 0) {
      _target = null;
      _generation++;
      super.pointerScroll(delta);
      return;
    }
    final pending = _target;
    // Reversing the wheel responds immediately instead of completing old travel.
    final base = pending != null &&
            isScrollingNotifier.value &&
            (pending - pixels) * delta > 0
        ? pending
        : pixels;
    final target = (base + delta).clamp(minScrollExtent, maxScrollExtent);
    _target = target;
    final generation = ++_generation;
    animateTo(target,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic)
        .whenComplete(() {
      if (generation == _generation) _target = null;
    });
  }
}

/// Opacity follows visible section area in either scroll direction. Long
/// sections stay fully readable while they fill the viewport.
class ScrollFade extends SingleChildRenderObjectWidget {
  const ScrollFade({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _FadeSection(
        Scrollable.of(context).position,
        MediaQuery.disableAnimationsOf(context),
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderProxyBox renderObject) {
    (renderObject as _FadeSection).update(Scrollable.of(context).position,
        MediaQuery.disableAnimationsOf(context));
  }
}

class _FadeSection extends RenderProxyBox {
  _FadeSection(this._position, this._reduceMotion);
  ScrollPosition _position;
  bool _reduceMotion;

  void update(ScrollPosition position, bool reduceMotion) {
    if (attached) _position.removeListener(markNeedsPaint);
    _position = position;
    _reduceMotion = reduceMotion;
    if (attached) _position.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _position.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _position.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final viewport = RenderAbstractViewport.maybeOf(this);
    if (_reduceMotion || viewport is! RenderBox || size.height == 0) {
      super.paint(context, offset);
      return;
    }
    final viewportBox = viewport as RenderBox;
    final top = localToGlobal(Offset.zero, ancestor: viewportBox).dy;
    final visible = (math.min(top + size.height, viewportBox.size.height) -
            math.max(top, 0))
        .clamp(0.0, double.infinity);
    final fraction =
        (visible / (math.min(size.height, viewportBox.size.height) * .72))
            .clamp(0.0, 1.0);
    final opacity = Curves.easeInOut.transform(fraction);
    context.pushOpacity(offset, (opacity * 255).round(), super.paint);
  }
}
