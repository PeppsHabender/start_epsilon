import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:start_page/utils/suggestions.dart';

import '../config/config_impl.dart';

class SearchBox extends StatelessWidget {
  final SearchBarController _controller = Get.put(SearchBarController());

  SearchBox({super.key});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: context.theme.colorScheme.onSurface),
          borderRadius: const BorderRadius.all(Radius.circular(50))
        ),
        child: Row(
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
                onSelected: (v) {
                  final String value = v.map((e) => e.part).join();

                  _controller._searchBarController.text = value;
                  _controller._searchBarController.selection = TextSelection(
                    baseOffset: value.length,
                    extentOffset: value.length
                  );
                },
                controller: _controller._searchBarController,
                suggestionsCallback: googleSuggestions,
                itemBuilder: (context, v) => ListTile(
                  title: Row(
                    children: v.map((e) => Text(e.part, style: e.matches ? TextStyle(color: context.theme.colorScheme.primary) : null)).toList(),
                  )
                ),
                decorationBuilder: (context, child) => Material(
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
                ),
                builder: (_, controller, focusNode) => TextField(
                  autofocus: true,
                  focusNode: focusNode,
                  onSubmitted: _controller.doSearch,
                  controller: controller,
                  decoration: const InputDecoration.collapsed(hintText: "Search the web..."),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(),
            )
          ],
        ),
      );
}

class SearchBarController extends GetxController {
  final TextEditingController _searchBarController = TextEditingController();

  String text() => _searchBarController.text;

  void doSearch([final String? search]) {
    final SearchConfig config = Get.find<IConfig>().searchConfig;

    context.callMethod("open", [config.engine.value.baseUri + (search ?? _searchBarController.text)]);

    _searchBarController.clear();
  }
}
