import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/controllers/icon_controller.dart';
import 'package:get/get.dart';
import 'package:rx_future/rx_future.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/config/config_impl.dart';

class AddBookmarkController extends GetxController {
  final TextEditingController idController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  final RxFuture<String?> iconUrl = RxFuture(null);
  final Rx<IconData?> selectedIcon = (null as IconData?).obs;
  final FIPIconController iconController = FIPIconController();

  final RxBool openInNewTab = true.obs;
  final Rx<Color?> primaryColor = (null as Color?).obs;

  final GeneralConfig config = Get.find<IConfig>().generalConfig;

  Timer? _typingTimer;

  Bookmark build() => Bookmark(
      idController.text,
      _sanitizeUri(urlController.text).toString(),
      iconUrl.value.value,
      selectedIcon.value,
      !openInNewTab.value,
      primaryColor.value
  );

  Uri _sanitizeUri(final String uri) {
    final String input = urlController.text;
    Uri parsed = Uri.parse(input);
    if(!parsed.hasScheme) parsed = Uri.parse("https://$input");

    return parsed;
  }

  void resetTimer() {
    _typingTimer?.cancel();
    _startTimer();
  }

  void _startTimer() => _typingTimer = Timer(
    const Duration(milliseconds: 500),
    () => iconUrl.observe(
      (_) async => _sanitizeUri(urlController.text).replace(path: "", queryParameters: null).resolve("favicon.ico").toString(),
      onError: (e) => iconUrl.value.value = null,
      multipleCallsBehavior: MultipleCallsBehavior.abortOld
    )
  );

  void reset() {
    idController.clear();
    urlController.clear();

    iconUrl.value.value = null;
    selectedIcon.value = null;
    iconController.searchTextController.text = "";

    openInNewTab.value = true;
    //primaryColor.value = null;
  }
}