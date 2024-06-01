import 'dart:ui';

import 'package:get/get.dart';
import 'package:start_page/config/config.dart';

class StartPageConfig extends IConfig {
  @override
  final SearchConfig searchConfig = SearchConfig._();

  @override
  final GeneralConfig generalConfig = GeneralConfig._();

  @override
  void save() {
    searchConfig.save();
  }

  @override
  void reload() {
    searchConfig.reload();
  }
}

enum SearchEngine {
  GOOGLE("https://www.google.com/search?q=");

  final String baseUri;

  const SearchEngine(this.baseUri);

  factory SearchEngine.from(final String name) =>
      SearchEngine.values.firstWhere((e) => e.name == name);
}

class SearchConfig extends IConfigElement {
  final Rx<SearchEngine> engine = SearchEngine.GOOGLE.obs;

  SearchConfig._();

  @override
  void reload() => _fromJson(getAsJson());

  Map<String, dynamic> toJson() => {"engine": engine.value.name};

  _fromJson(Map<String, dynamic> json) {
    engine.value = SearchEngine.from(json["engine"] as String);
  }
}

class GeneralConfig extends IConfigElement {
  final RxString folderSeparator = ">".obs;
  final RxString corsProxy = "https://corsproxy.io/?".obs;
  final Rx<Color?> primaryColor = (null as Color?).obs;

  GeneralConfig._();

  @override
  void reload() => _fromJson(getAsJson());

  Map<String, dynamic> toJson() => {
    "folderSeparator": folderSeparator.value,
    "corsProxy": corsProxy.value,
    "primaryColor": primaryColor.value
  };

  _fromJson(Map<String, dynamic> json) {
    folderSeparator.value = json["folderSeparator"];
    corsProxy.value = json["corsProxy"];
    primaryColor.value = json["primaryColor"];
  }
}