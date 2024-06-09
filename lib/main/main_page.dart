import 'dart:math';

import 'package:animated_path/animated_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/abstract.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/bookmarks/flat_bookmarks/flat_bookmark_view.dart';
import 'package:start_page/search/search_bar.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

part 'main_page_widgets.dart';

class MainPage extends StatelessWidget {
  final MainController _controller = Get.put(MainController());

  MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Center(child: _BackgroundAnimation()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                          width: max(400, context.width / 3.5),
                          height: 40,
                          child: SearchBox()
                      ),
                    ),
                  ),
                  IconButton.outlined(
                      onPressed: () => _controller._closeable.value == null
                          ? _controller.showWidget(AddBookmark())
                          : _controller.closeWidget(AddBookmark),
                      icon: _controller._closeable.ReadOnlyWidget((h) => Icon(h == null ? Icons.add : Icons.close, size: 30))
                  ),
                ],
              ),
            ),
            _controller._closeable.ReadOnlyWidget((widget) => widget ?? const SizedBox()),
            const SizedBox(height: 15),
            Expanded(
                child: Align(alignment: Alignment.topLeft, child: FlatBookmarkView())
            ),
          ],
        ),
      ],
    ),
  );
}


class MainController extends GetxController {
  final Rx<StatelessWidget?> _closeable = (null as StatelessWidget?).obs;

  void showWidget(final CloseableWidget caller) {
    if(_closeable.value != null) return;

    _closeable.value = caller;
  }

  void closeWidget(final Type callerType) {
    if(_closeable.value.runtimeType != callerType) return;

    _closeable.value = null;
  }
}