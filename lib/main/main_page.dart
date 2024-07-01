import 'dart:math';

import 'package:animated_path/animated_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/abstract.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/bookmarks/flat_bookmarks/flat_bookmark_view.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/config/config_impl.dart';
import 'package:start_page/config/view/drawer_view.dart';
import 'package:start_page/search/search_bar.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/utils.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

part 'main_page_widgets.dart';

class MainPage extends StatelessWidget {
  final MainController _controller = Get.put(MainController());
  final IConfig config = Get.find();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Center(
          child: config.generalConfig.secondaryColor.combine(config.generalConfig.primaryColor).ReadOnlyWidget(
            (colors) => _BackgroundAnimation(colors: [colors.$1, colors.$2], key: UniqueKey())
          )
        ),
        Positioned.fill(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _topBar(context),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    _controller._widgets[WidgetType.drawer]!.ReadOnlyWidgetN((widget) => widget),
                    Expanded(
                      child: Column(
                        children: [
                          _controller._widgets[WidgetType.topBar]!.ReadOnlyWidgetN((widget) => widget),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                Expanded(child: Align(alignment: Alignment.topLeft, child: FlatBookmarkView())),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _topBar(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _DrawerButton(),
        Expanded(
          child: Center(
            child: SizedBox(
              width: max(400, context.width / 3.5),
              height: 40,
              child: SearchBox()
            ),
          ),
        ),
        Get.find<IConfig>().generalConfig.primaryColor.ReadOnlyWidget(
          (color) => IconButton.outlined(
            style: ButtonStyle(side: WidgetStateProperty.all(BorderSide(color: color))),
            onPressed: () => _controller._widgets[WidgetType.topBar]!.value == null
                ? _controller.showWidget(AddBookmark(), WidgetType.topBar)
                : _controller.closeWidget(AddBookmark, WidgetType.topBar),
            icon: _controller._widgets[WidgetType.topBar]!.ReadOnlyWidget((h) => Icon(h == null ? Icons.add : Icons.close, size: 30))
          ),
        )
      ],
    ),
  );
}

class MainController extends GetxController {
  final Map<WidgetType, Rxn<Widget>> _widgets = {
    WidgetType.topBar : Rxn(),
    WidgetType.drawer : Rxn()
  };

  Widget? widget(WidgetType type) {
    return _widgets[type]!.value;
  }

  void showWidget(final Closeable caller, final WidgetType type) {
    final Rx<Widget?> toCheck = _widgets[type]!;
    if(toCheck.value != null) return;

    toCheck.value = caller;
  }

  void closeWidget(final Type callerType, final WidgetType type) {
    final Rx<Widget?> toCheck = _widgets[type]!;
    if(toCheck.value.runtimeType != callerType) return;

    toCheck.value = null;
  }
}

enum WidgetType {
  topBar, drawer;
}