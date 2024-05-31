import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:start_page/main/main_page.dart';

abstract class CloseableWidget extends StatelessWidget {
  CloseableWidget({super.key}) {
    Get.find<MainController>().showWidget(this);
  }

  @protected
  @nonVirtual
  void close() => Get.find<MainController>().closeWidget(runtimeType);
}