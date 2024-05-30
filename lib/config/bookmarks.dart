import 'dart:convert';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter_iconpicker/Serialization/icondata_serialization.dart';
import 'package:get/get.dart';

abstract class IComponent {
  abstract final String id;

  IComponent _addBookmark(final List<String> ids, final Bookmark bookmark);
}

class Nested extends IComponent {
  @override
  final String id;
  final List<IComponent> children;

  Nested(this.id, this.children);

  @override
  IComponent _addBookmark(List<String> ids, Bookmark bookmark) {
    final String curr = ids.removeAt(0);
    if(ids.isEmpty) {
      bookmark._setId(curr);
      return this..children.add(bookmark);
    }

    final IComponent? matching = children.firstWhereOrNull((e) => e.id == curr);
    if(matching != null) {
      matching._addBookmark(ids, bookmark);
      return this;
    }

    return this..children.add(Nested(curr, [])._addBookmark(ids, bookmark));
  }
}

class Bookmark extends IComponent {
  String _id;
  final String url;
  final String? iconUri;
  final IconData? iconData;
  final bool? openInSame;
  final Color? primaryColor;

  @override
  String get id => _id;

  void _setId(final String id) => _id = id;

  Bookmark(this._id, this.url, this.iconUri, this.iconData, this.openInSame, this.primaryColor);

  factory Bookmark.fromJson(final Map<String, dynamic> json) => Bookmark(
    json["id"] ?? "",
    json["url"],
    json["iconUri"],
    json["iconData"] == null ? null : deserializeIcon(json["iconData"]),
    json["openInSame"],
    json["primaryColor"] == null ? null : Color(json["primaryColor"])
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "iconUri": iconUri,
    "iconData": iconData == null ? null : serializeIcon(iconData!),
    "openInSame": openInSame,
    "primaryColor": primaryColor?.value
  };

  @override
  IComponent _addBookmark(List<String> ids, Bookmark bookmark) {
    final String curr = ids.removeAt(0);
    if(ids.isEmpty) {
      return bookmark.._setId(curr);
    }

    return Nested(curr, [this.._setId("~")])._addBookmark(ids, bookmark);
  }
}

abstract class IBookmarkService {
  static void bind() => Get.lazyPut<IBookmarkService>(() => _BookmarkService());

  abstract final RxList<Rx<IComponent>> components;

  void addBookmark(final Bookmark bookmark);
}

class _BookmarkService extends IBookmarkService {
  static const String _separator = ">";
  static const String _prefix = "BOOKMARK\$";
  static final Storage _storage = window.localStorage;

  @override
  final RxList<Rx<IComponent>> components = <Rx<IComponent>>[].obs;

  _BookmarkService() {
    _storage.entries.where((e) => e.key.startsWith(_prefix))
        .map((e) => MapEntry(e.key.substring(_prefix.length), e.value))
        .map((e) => Bookmark.fromJson(jsonDecode(e.value) as Map<String, dynamic>).._setId(e.key))
        .forEach(addBookmark);
  }

  @override
  void addBookmark(Bookmark bookmark) {
    _storage[_prefix + bookmark.id] = jsonEncode(bookmark);
    final List<String> idSplit = bookmark.id.split(_separator);

    final Rx<IComponent>? matching = components.firstWhereOrNull((e) => e.value.id == idSplit[0]);
    if(matching == null && idSplit.length == 1) {
      components.add(bookmark.obs);
    } else if(matching == null) {
      components.add((Nested(idSplit.removeAt(0), []).._addBookmark(idSplit, bookmark)).obs);
    } else {
      matching.value = matching.value._addBookmark(idSplit..removeAt(0), bookmark);
    }
  }
}