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

  static final _blurPaint = _createPaint(strokeWidth: 10, maskFilter: const MaskFilter.blur(BlurStyle.normal, 10));
  static final _sharpPaint = _createPaint(strokeWidth: 6);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final RxBool _animFinished = false.obs;

  _BackgroundAnimationState() {
    Future.microtask(() {
      _controller.addStatusListener((s) {
        if(s == AnimationStatus.completed) {
          _animFinished.value = true;
        }
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) => _animFinished.ReadOnlyWidget(
    (finished) => Stack(
      children: [
        ...finished ? [
          _NeonFlickerEffect(path: _epsilon),
          CustomPaint(painter: PathPainter.paint(path: _epsilon, paint: _createPaint()))
        ] : [
          _createPath(paint: _blurPaint),
          _createPath(
              paint: _blurPaint,
              start: Tween(begin: 0.0, end: 0.7),
              end: Tween(begin: 0.1, end: 1.0),
              offset: Tween(begin: 0.0, end: 0.3)
          ),
          _createPath(
              start: Tween(begin: 0.0, end: 0.7),
              end: Tween(begin: 0.1, end: 1.0),
              offset: Tween(begin: 0.0, end: 0.3)
          ),
          _createPath(),
        ],
      ],
    ),
  );

  AnimatedPath _createPath({Paint? paint, Tween<double>? start, Tween<double>? end, Tween<double>? offset}) => AnimatedPath(
    animation: _animation,
    path: _epsilon,
    paint: paint ?? _sharpPaint,
    start: start,
    end: end ?? Tween(begin: 0.0, end: 1.0),
    offset: offset ?? Tween(begin: -0.5, end: 0.0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static Paint _createPaint({MaskFilter? maskFilter, double? strokeWidth}) => Paint()
    ..strokeWidth = strokeWidth ?? 7
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.bevel
    ..maskFilter = maskFilter
    ..shader = _gradientShader;
}

class _NeonFlickerPainter extends CustomPainter {
  final Path path;
  final Color color;

  _NeonFlickerPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _NeonFlickerEffect extends StatefulWidget {
  final Path path;
  final List<Color> colors;

  const _NeonFlickerEffect({required this.path, this.colors = const [Colors.red, Colors.pink, Colors.purple]});

  @override
  _NeonFlickerEffectState createState() => _NeonFlickerEffectState();
}

class _NeonFlickerEffectState extends State<_NeonFlickerEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = TweenSequence(
      widget.colors.mapIndexed((idx, e) => TweenSequenceItem(
        tween: ColorTween(
            begin: e,
            end: widget.colors[(idx + 1) % widget.colors.length]
        ),
        weight: 1
      )).toList()
    ).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CustomPaint(
        painter: _NeonFlickerPainter(widget.path, _animation.value!),
      ),
    );
  }
}