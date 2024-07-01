import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:start_page/main/main_page.dart';

abstract class Closeable implements Widget {}

mixin CloseableDrawerWidget implements Closeable {
  @protected
  @nonVirtual
  void close() => Get.find<MainController>().closeWidget(runtimeType, WidgetType.drawer);
}

mixin CloseableTopBarWidget implements Closeable {
  @protected
  @nonVirtual
  void close() => Get.find<MainController>().closeWidget(runtimeType, WidgetType.topBar);
}