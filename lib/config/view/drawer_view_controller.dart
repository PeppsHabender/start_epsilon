import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:start_page/config/config.dart';

class ConfigDrawerController extends GetxController {
  final TextEditingController corsProxyController = TextEditingController();
  final TextEditingController folderSeparatorController = TextEditingController();
  late final Rx<Color> primaryColor;
  late final Rx<Color> secondaryColor;

  ConfigDrawerController() {
    final IConfig config = Get.find();
    corsProxyController.text = config.generalConfig.corsProxy.value;
    final String sep = config.generalConfig.folderSeparator.value;
    if(sep != ">") folderSeparatorController.text = sep;
    primaryColor = config.generalConfig.primaryColor.value.obs;
    secondaryColor = config.generalConfig.secondaryColor.value.obs;
  }

  @override
  InternalFinalCallback<void> get onDelete {
    return InternalFinalCallback(callback: () {
      Future.microtask(() {
        final IConfig config = Get.find();
        config.generalConfig.corsProxy.value = corsProxyController.text;
        config.generalConfig.folderSeparator.value = folderSeparatorController.text;
        config.generalConfig.primaryColor.value = primaryColor.value;
        config.generalConfig.secondaryColor.value = secondaryColor.value;

        config.save();
      });
    });
  }
}