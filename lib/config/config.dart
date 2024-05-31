import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:start_page/config/config_impl.dart';

abstract class IConfig extends IConfigElement {
  abstract final SearchConfig searchConfig;
  abstract final GeneralConfig generalConfig;
}

abstract class IConfigElement {
  final Storage _storage = window.localStorage;

  void save() => _storage[runtimeType.toString()] = jsonEncode(this);
  void reload();

  @protected
  @nonVirtual
  Map<String, dynamic> getAsJson() {
    final String? json = _storage[runtimeType.toString()];

    return json == null ? {} : jsonDecode(json);
  }
}