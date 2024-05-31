import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark_controller.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/main/main_page.dart';
import 'package:start_page/utils/extensions.dart';

class NeonBookmarkView extends StatelessWidget {
  final Bookmark bookmark;
  final RxBool _rightClicked = false.obs;

  NeonBookmarkView(this.bookmark, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = bookmark.primaryColor ?? Colors.transparent;

    return SizedBox(
      height: 150,
      width: 150,
      child: _rightClicked.ReadOnlyWidget((r) {
        final List<Widget> addItems = [];
        if(r) {
          addItems.add(
            Expanded(
              child: Container(
                decoration: _boxDeco(borderColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () {
                      Get.find<MainController>().closeWidget(AddBookmark);
                      Get.find<MainController>().showWidget(AddBookmark(bookmark: bookmark));
                      _rightClicked.toggle();
                    }, icon: const Icon(Icons.edit, size: 20,)),
                    IconButton(onPressed: () => Get.find<IBookmarkService>().removeBookmark(bookmark), icon: const Icon(Icons.delete, size: 20,))
                  ],
                ),
              ),
            )
          );
          addItems.add(const SizedBox(height: 5));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...addItems,
            Expanded(flex: 3, child: _bookmarkView(borderColor))
          ],
        );
      }),
    );
  }

  Widget _bookmarkView(final Color borderColor) => InkWell(
    onTap: _openUrl,
    onSecondaryTap: _rightClicked.toggle,
    child: ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: 150,
          decoration: _boxDeco(borderColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _bookmarkIcon(),
              Text(bookmark.id.substring(bookmark.id.lastIndexOf(">") + 1))
            ],
          ),
        ),
      ),
    ),
  );

  BoxDecoration _boxDeco(final Color borderColor) => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: borderColor),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [BoxShadow(color: borderColor, blurRadius: 3, blurStyle: BlurStyle.outer)]
  );

  Widget _bookmarkIcon() {
    final IconData? iconData = bookmark.iconData;
    final String? iconUri = bookmark.iconUri;

    if(iconData == null && iconUri == null) {
      return const SizedBox();
    }

    if(iconData != null) {
      return Icon(iconData, size: 70, color: bookmark.primaryColor);
    }

    return ImageNetwork(
      onTap: _openUrl,
      image: bookmark.iconUri ?? "",
      height: 70,
      width: 70,
    );
  }

  void _openUrl() =>
      (bookmark.openInSame ?? false) ? window.location.href = bookmark.url : window.open(bookmark.url, "new tab");
}