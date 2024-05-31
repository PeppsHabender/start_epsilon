import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark_controller.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/abstract.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/widgets.dart';

part 'add_bookmark_helper.dart';

class AddBookmark extends CloseableWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Bookmark? bookmark;

  AddBookmark({super.key, this.bookmark}) {
    Get.lazyPut(() => AddBookmarkController());
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AddBookmarkController>().primaryColor.value ??= context.theme.colorScheme.onSurface;
    Get.find<AddBookmarkController>().adjustTo(bookmark);

    return Center(
      child: SizedBox(
        width: max(450, context.width / 4),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              _neonBorder(context),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _header(context),
                      _idTextfield(),
                      const SizedBox(height: 15),
                      _urlIconEditor(context),
                      const SizedBox(height: 15),
                      Expandable(
                        title: "Additional Settings",
                        color: Get.find<AddBookmarkController>().primaryColor,
                        child: _additionalSettings()
                      ),
                      const SizedBox(height: 20),
                      _submitButton(context, _formKey, super.close)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}