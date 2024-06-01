import 'dart:convert';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter_iconpicker/Serialization/icondata_serialization.dart';
import 'package:get/get.dart';
import 'package:start_page/config/config.dart';

const String _prefix = "BOOKMARK\$";

abstract class IComponent {
  abstract final String _id;

  String get id => _id.substring(_id.lastIndexOf(IBookmarkService.separator()) + 1);

  IComponent _addBookmark(final List<String> ids, final Bookmark bookmark);

  bool _removeBookmark(final List<String> ids, final Bookmark bookmark);
}

class Nested extends IComponent {
  @override
  final String _id;
  final List<IComponent> children;

  Nested(this._id, this.children);

  @override
  IComponent _addBookmark(List<String> ids, Bookmark bookmark) {
    final String curr = ids.removeAt(0);
    if(ids.isEmpty) {
      return this..children.add(bookmark);
    }

    final IComponent? matching = children.firstWhereOrNull((e) => e is Nested && e.id == curr);
    if(matching != null) {
      matching._addBookmark(ids, bookmark);
      return this;
    }

    return this..children.add(Nested(curr, [])._addBookmark(ids, bookmark));
  }

  @override
  bool _removeBookmark(List<String> ids, Bookmark bookmark) {
    if(ids.isEmpty) return true;

    final String curr = ids.removeAt(0);
    final IComponent? matching = children.firstWhereOrNull((e) => (ids.isEmpty ? e is Bookmark : e is Nested) && e.id == curr);
    final bool result = matching?._removeBookmark(ids, bookmark) ?? false;

    if(result) {
      children.removeWhere((e) => e == matching);
    }

    return children.isEmpty;
  }
}

class Bookmark extends IComponent {
  @override
  String _id;
  final String url;
  final String? iconUri;
  final IconData? iconData;
  final bool? openInSame;
  final Color? primaryColor;

  void _setId(final String id) => _id = id;

  String get wholeId => _id;

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

  Bookmark copyWith({
    String? id,
    String? url,
    String? iconUri,
    IconData? iconData,
    bool? openInSame,
    Color? primaryColor
  }) => Bookmark(
    id ?? _id,
    url ?? this.url,
    iconUri ?? this.iconUri,
    iconData ?? this.iconData,
    openInSame ?? this.openInSame,
    primaryColor ?? this.primaryColor
  );

  @override
  IComponent _addBookmark(List<String> ids, Bookmark bookmark) {
    final String curr = ids.removeAt(0);
    if(ids.isEmpty) {
      return bookmark;
    }

    return Nested(curr, [this.._setId("~")])._addBookmark(ids, bookmark);
  }

  @override
  bool _removeBookmark(List<String> ids, Bookmark bookmark) => true;
}

abstract class IBookmarkService {
  static void bind() => Get.lazyPut<IBookmarkService>(() => _BookmarkService());

  abstract final RxList<Rx<IComponent>> components;

  void addBookmark(final Bookmark bookmark, [final Bookmark? old]);
  void removeBookmark(Bookmark bookmark);

  static String separator() => Get.find<IConfig>().generalConfig.folderSeparator.value;
}

class _BookmarkService extends IBookmarkService {
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
  void addBookmark(Bookmark bookmark, [final Bookmark? old]) {
    if(old != null) removeBookmark(old);

    _storage[_prefix + bookmark._id] = jsonEncode(bookmark);
    final List<String> idSplit = bookmark._id.split(IBookmarkService.separator());

    final Rx<IComponent>? matching = components.firstWhereOrNull((e) => e.value.id == idSplit[0]);
    if(idSplit.length == 1) {
      components.add(bookmark.obs);
    } else if(matching == null || matching.value is Bookmark) {
      components.add((Nested(idSplit.removeAt(0), []).._addBookmark(idSplit, bookmark)).obs);
    } else {
      matching.value = matching.value._addBookmark(idSplit..removeAt(0), bookmark);
    }

    components.refresh();
  }

  @override
  void removeBookmark(Bookmark bookmark) {
    _storage.remove(_prefix + bookmark._id);
    final List<String> idSplit = bookmark._id.split(IBookmarkService.separator());

    final String fst = idSplit.removeAt(0);
    final Rx<IComponent>? matching = components.firstWhereOrNull((e) => e.value.id == fst);
    final bool result = matching?.value._removeBookmark(idSplit, bookmark) ?? false;

    if(result) {
      components.removeWhere((e) => e.value == matching?.value);
    }

    components.refresh();
  }
}