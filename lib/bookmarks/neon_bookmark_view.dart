import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:start_page/config/bookmarks.dart';

class NeonBookmarkView extends StatelessWidget {
  final Bookmark bookmark;

  const NeonBookmarkView(this.bookmark, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = bookmark.primaryColor ?? Colors.transparent;

    return InkWell(
      onTap: _openUrl,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: borderColor, blurRadius: 3, blurStyle: BlurStyle.outer)]
            ),
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bookmarkIcon(),
                Text(bookmark.id)
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      bookmark.openInSame ?? false ? window.location.href = bookmark.url : window.open(bookmark.url, "new tab");
}