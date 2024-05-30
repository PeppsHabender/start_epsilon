import 'dart:math';
import 'dart:ui';

import 'package:start_page/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launch(String url, {bool isNewTab = true}) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
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