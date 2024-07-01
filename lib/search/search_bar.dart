import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/suggestions.dart';

import '../config/config_impl.dart';

class SearchBox extends StatelessWidget {
  final SearchBarController _controller = Get.put(SearchBarController());
  final IConfig _config = Get.find();
  final FocusNode node = FocusNode();

  SearchBox({super.key});

  @override
  Widget build(BuildContext context) => _config.generalConfig.primaryColor.ReadOnlyWidget((color) => Container(
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      border: Border.all(width: 1.5, color: color ?? context.theme.colorScheme.onSurface),
      borderRadius: const BorderRadius.all(Radius.circular(50))
    ),
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (e) {
        if(e is KeyUpEvent && e.logicalKey == LogicalKeyboardKey.arrowDown) {
          node.nextFocus();
        }
      },
      child: _searchBar()
    ),
  ));

  Widget _searchBar() => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AspectRatio(
        aspectRatio: 1,
        child: IconButton(
          onPressed: _controller.doSearch,
          icon: const Icon(Icons.search)
        ),
      ),
      Expanded(
        child: TypeAheadField<List<SearchResult>>(
          retainOnLoading: true,
          hideOnEmpty: true,
          debounceDuration: const Duration(milliseconds: 200),
          onSelected: _select,
          controller: _controller._searchBarController,
          suggestionsCallback: googleSuggestions,
          itemBuilder: (context, results) => _item(context, results, node),
          decorationBuilder: (context, child) => _decoration(context, child),
          builder: (_, controller, focusNode) => _searchField(focusNode, controller, _controller)
        ),
      ),
      AspectRatio(
        aspectRatio: 1,
        child: Container(),
      )
    ],
  );

  void _select(final List<SearchResult> result) {
    final String value = result.map((e) => e.part).join();

    _controller._searchBarController.text = value;
    _controller._searchBarController.selection = TextSelection(
      baseOffset: value.length,
      extentOffset: value.length
    );
  }
}

ListTile _item(
    final BuildContext context,
    final List<SearchResult> results,
    final FocusNode focusNode
) => ListTile(
    focusNode: focusNode,
    title: Row(
      children: [...results.map((e) => Text(e.part, style: e.matches ? TextStyle(color: context.theme.colorScheme.primary) : null))],
    )
);

Widget _decoration(final BuildContext context, final Widget child) => Material(
  type: MaterialType.card,
  elevation: 8,
  color: context.theme.colorScheme.surface.darker(0.02),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
      )
  ),
  child: child,
);

TextField _searchField(
    final FocusNode focusNode,
    final TextEditingController text,
    final SearchBarController controller
) => TextField(
  autofocus: true,
  focusNode: focusNode,
  onSubmitted: controller.doSearch,
  controller: text,
  decoration: const InputDecoration.collapsed(hintText: "Search the web..."),
);

class SearchBarController extends GetxController {
  final TextEditingController _searchBarController = TextEditingController();

  String text() => _searchBarController.text;

  void doSearch([final String? search]) {
    final SearchConfig config = Get.find<IConfig>().searchConfig;

    context.callMethod("open", [config.engine.value.baseUri.format([search ?? _searchBarController.text])]);

    _searchBarController.clear();
  }
}
