import 'dart:math';

import 'package:animated_path/animated_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/bookmarks/flat_bookmarks/flat_bookmark_view.dart';
import 'package:start_page/search/search_bar.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

part 'main_page_widgets.dart';

class MainPage extends StatelessWidget {
  final RxDouble height = .0.obs;

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
                        onPressed: () => height.value = height.value == 0 ? 300 : 0,
                        icon: height.ReadOnlyWidget((h) => Icon(h == 0 ? Icons.add : Icons.close, size: 30))
                    ),
                  ],
                ),
              ),
              height.ReadWriteWidget((h, write) => h == 0 ? Container() : AddBookmark(close: () => write(0))),
              const SizedBox(height: 15),
              Expanded(
                  child: Align(alignment: Alignment.topLeft, child: FlatBookmarkView())
              ),
            ],
          ),
        ],
      )
  );
}