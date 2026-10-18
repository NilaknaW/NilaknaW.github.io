import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

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
  @override
  void pointerScroll(double delta) {
    if (reduceMotion() || delta == 0) {
      super.pointerScroll(delta);
      return;
    }
    updateUserScrollDirection(
      delta < 0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );
    final current = activity;
    if (current is _WheelActivity) {
      current.addDelta(delta);
    } else {
      final wheel = _WheelActivity(this, context.vsync);
      beginActivity(wheel);
      wheel.addDelta(delta);
    }
  }
}

/// One ongoing activity accepts wheel updates without restarting its clock or
/// disabling hit testing on project cards while the wheel settles.
class _WheelActivity extends ScrollActivity {
  _WheelActivity(_WheelPosition position, TickerProvider vsync)
      : _target = position.pixels,
        super(position) {
    _ticker = vsync.createTicker(_tick)..start();
  }

  late final Ticker _ticker;
  double _target;
  Duration _lastTime = Duration.zero;
  double _velocity = 0;
  _WheelPosition get position => delegate as _WheelPosition;

  void addDelta(double delta) {
    final remaining = _target - position.pixels;
    final base = remaining * delta > 0 ? _target : position.pixels;
    _target = (base + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _lastTime).inMicroseconds / 1000000;
    _lastTime = elapsed;
    if (dt <= 0) return;
    _target = _target.clamp(position.minScrollExtent, position.maxScrollExtent);
    final remaining = _target - position.pixels;
    final next = remaining.abs() < .2
        ? _target
        : position.pixels + remaining * (1 - math.exp(-dt * 18));
    _velocity = (next - position.pixels) / dt;
    final overscroll = delegate.setPixels(next);
    if (overscroll != 0) {
      delegate.goBallistic(0);
    } else if ((_target - position.pixels).abs() < .2) {
      delegate.setPixels(_target);
      delegate.goBallistic(0);
    }
  }

  @override
  bool get shouldIgnorePointer => false;
  @override
  bool get isScrolling => true;
  @override
  double get velocity => _velocity;
  @override
  void resetActivity() => delegate.goBallistic(0);
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
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
