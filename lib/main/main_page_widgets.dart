part of 'main_page.dart';

class _BackgroundAnimation extends StatefulWidget {
  const _BackgroundAnimation();

  @override
  State<_BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<_BackgroundAnimation> with SingleTickerProviderStateMixin {
  static final Path _epsilon = parseSvgPath("M -152 -160 L 152 -160 L 152 -80 L 120 -112 L -56 -112 L 40 0 L -56 128 L 120 128 L 152 -32 L 152 176 L -152 176 L -14 0 L -152 -160");
  static final Shader _gradientShader = const RadialGradient(
    center: Alignment.center,
    radius: 20,
    colors: [Colors.red, Colors.purple],
  ).createShader(Offset.zero & const Size(15, 15));
  static final _blurPaint = _createPaint(maskFilter: const MaskFilter.blur(BlurStyle.normal, 2));
  static final _sharpPaint = _createPaint(strokeWidth: 6);

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  late final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.linear,
  );

  _BackgroundAnimationState() {
    Future.microtask(() => animationController.forward());
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _createPath(paint: _blurPaint),
      _createPath(
        paint: _blurPaint,
        start: Tween(begin: 0.0, end: 0.7),
        end: Tween(begin: 0.1, end: 1.0),
        offset: Tween(begin: 0.0, end: 0.3)
      ),
      _createPath(),
      _createPath(
        start: Tween(begin: 0.0, end: 0.7),
        end: Tween(begin: 0.1, end: 1.0),
        offset: Tween(begin: 0.0, end: 0.3)
      ),
    ],
  );

  AnimatedPath _createPath({Paint? paint, Tween<double>? start, Tween<double>? end, Tween<double>? offset}) => AnimatedPath(
    animation: animation,
    path: _epsilon,
    paint: paint ?? _sharpPaint,
    start: start,
    end: end ?? Tween(begin: 0.0, end: 1.0),
    offset: offset ?? Tween(begin: -0.5, end: 0.0),
  );

  static Paint _createPaint({MaskFilter? maskFilter, double? strokeWidth}) => Paint()
    ..strokeWidth = strokeWidth ?? 7
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.bevel
    ..maskFilter = maskFilter
    ..shader = _gradientShader;
}