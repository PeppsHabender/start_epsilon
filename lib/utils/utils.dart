import 'package:flutter/rendering.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launch(String url, {bool isNewTab = true}) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? null : "_self",
  );
}

Color? averageColor(final Iterable<Color> colors) {
  final int len = colors.length;
  final result = colors.map((e) => (e.red, e.green, e.blue))
    .reduceOrNull((a, b) => (a.$1 + b.$1, a.$2 + b.$2, a.$3 + b.$3));

  return result == null ? null : Color.fromARGB(
      255,
      result.$1 ~/ len,
      result.$2 ~/ len,
      result.$3 ~/ len
  );
}

class PathPainter extends CustomPainter {
  final Path path;
  final Paint painter;
  final bool Function(CustomPainter)? shouldRebuild;

  PathPainter({
    required this.path,
    this.shouldRebuild,
    double strokeWidth = 5,
    StrokeCap strokeCap = StrokeCap.round,
    PaintingStyle style = PaintingStyle.stroke,
    bool isAntiAlias = true,
    StrokeJoin strokeJoin = StrokeJoin.round,
    MaskFilter? maskFilter,
    Shader? shader
  }) : painter = Paint()
    ..strokeWidth = strokeWidth
    ..strokeCap = strokeCap
    ..style = style
    ..isAntiAlias = isAntiAlias
    ..strokeJoin = strokeJoin
    ..maskFilter = maskFilter
    ..shader = shader;

  PathPainter.paint({
    required this.path,
    required Paint paint,
    this.shouldRebuild
  }) : painter = paint;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(path, painter);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => shouldRebuild?.call(oldDelegate) ?? false;
}