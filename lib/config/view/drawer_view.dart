import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:start_page/abstract.dart';
import 'package:start_page/config/view/drawer_view_controller.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/widgets.dart';

class ConfigDrawer extends StatefulWidget with CloseableDrawerWidget {
  const ConfigDrawer({super.key});

  @override
  State<ConfigDrawer> createState() => _ConfigDrawerState();
}

class _ConfigDrawerState extends State<ConfigDrawer> {
  @override
  void initState() {
    Get.put(ConfigDrawerController());

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ConfigDrawerController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: max(400, context.width / 3),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("General Configuration", style: context.textTheme.headlineMedium),
              _textElement("Cors Proxy", "No CORS proxy set", Get.find<ConfigDrawerController>().corsProxyController),
              const SizedBox(height: 10),
              _textElement("Folder Separator", "Using default separator.. (>)", Get.find<ConfigDrawerController>().folderSeparatorController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Primary Color"),
                  _colorPicker(context, Get.find<ConfigDrawerController>().primaryColor)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Secondary Color"),
                  _colorPicker(context, Get.find<ConfigDrawerController>().secondaryColor)
                ],
              ),
            ],
          ),
        ),
      )
  );
}

Widget _textElement(final String text, final String hint, final TextEditingController controller) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(child: Align(alignment: Alignment.bottomLeft, child: Text(text))),
    Expanded(
      child: FocusColorChangingTextFormField(
        color: Get.find<ConfigDrawerController>().primaryColor,
        border: (c) => c == null ? const OutlineInputBorder() : OutlineInputBorder(borderSide: BorderSide(color: c)),
        hintText: hint,
        controller: controller,
      )
    )
  ],
);

Widget _colorPicker(final BuildContext context, final Rx<Color> rxColor) => InkWell(
    onTap: () => Get.dialog(
        Center(
          child: Card(
            child: BlockPicker(
              pickerColor: rxColor.value,
              onColorChanged: (color) {
                rxColor.value = color;
                Get.back(closeOverlays: true);
              },
            ),
          ),
        )
    ),
    child: _colorPickerContent(context, rxColor)
);

Widget _colorPickerContent(final BuildContext context, final Rx<Color> color) => color.ReadOnlyWidget(
  (color) => Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color,
          blurStyle: BlurStyle.outer,
          blurRadius: 3
        )
      ]
    ),
  )
);