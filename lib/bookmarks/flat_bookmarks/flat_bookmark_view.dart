import 'dart:html';

import 'package:color_extract/color_extract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:start_page/bookmarks/neon_bookmark_view.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/utils.dart';

part 'flat_folder_view.dart';

class FlatBookmarkView extends StatelessWidget {
  final IBookmarkService _service = Get.find();
  
  FlatBookmarkView({super.key});

  @override
  Widget build(BuildContext context) => _service.components.ReadOnlyWidget(
    (components) => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Wrap(
                spacing: 15,
                children: components.whereType<Rx<Bookmark>>()
                    .map((e) => e.ReadOnlyWidget((value) => NeonBookmarkView(value))).toList(),
              ),
            ),
            const SizedBox(height: 15)
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: components.whereType<Rx<Nested>>()
                .map((e) => e.ReadOnlyWidget((value) => _FlatFolderView(1, value))).toList(),
          )
        ],
      )
    )
  );

  static int compareRx(final Rx<IComponent> a, final Rx<IComponent> b) => compare(a.value, b.value);

  static int compare(final IComponent a, final IComponent b) {
    if(a is Bookmark) return b is Bookmark ? 0 : -1;
    return b is Bookmark ? 1 : 0;
  }
}