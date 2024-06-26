import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/main/main_page.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/utils.dart';

class NeonBookmarkView extends StatelessWidget {
  final Bookmark bookmark;
  final RxBool _rightClicked = false.obs;

  NeonBookmarkView(this.bookmark, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    width: 150,
    child: _rightClicked.combine(bookmark.primaryColor).ReadOnlyWidget((r) {
      final List<Widget> addItems = [];
      if(r.$1) {
        addItems.add(
          Expanded(
            child: Container(
              decoration: _boxDeco(context, r.$2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () {
                    Get.find<MainController>().closeWidget(AddBookmark, WidgetType.topBar);
                    Get.find<MainController>().showWidget(AddBookmark(bookmark: bookmark), WidgetType.topBar);
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
          Expanded(flex: 3, child: _bookmarkView(context, r.$2))
        ],
      );
    }),
  );

  Widget _bookmarkView(final BuildContext context, final Color borderColor) => bookmark.primaryColor.ReadOnlyWidget(
    (color) => InkWell(
      onTap: _openUrl,
      onSecondaryTap: _rightClicked.toggle,
      hoverColor: context.theme.highlightColor.lighter(),
      splashColor: color,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 150,
        decoration: _boxDeco(context, borderColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bookmarkIcon(),
            Get.find<IConfig>().generalConfig.folderSeparator.ReadOnlyWidget((separator) =>
              Text(bookmark.id.substring(separator.isEmpty ? 0 : bookmark.id.lastIndexOf(separator) + 1)
            ))
          ],
        ),
      ),
    )
  );

  BoxDecoration _boxDeco(final BuildContext context, final Color borderColor) => BoxDecoration(
    color: context.theme.colorScheme.surface.withOpacity(0.8),
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
      return bookmark.primaryColor.ReadOnlyWidget((color) => Icon(iconData, size: 70, color: color));
    }

    return ImageNetwork(
      onTap: _openUrl,
      image: bookmark.iconUri ?? "",
      height: 70,
      width: 70,
    );
  }

  void _openUrl() => launch(bookmark.url, isNewTab: !(bookmark.openInSame ?? false));
}