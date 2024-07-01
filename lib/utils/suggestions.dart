import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:start_page/config/config.dart';
import 'package:start_page/utils/extensions.dart';

import '../config/config_impl.dart';

typedef SearchResult = ({String part, bool matches});

Future<List<List<SearchResult>>?> googleSuggestions(final String base, {final int size = 5}) async {
  final GeneralConfig config = Get.find<IConfig>().generalConfig;
  if(config.corsProxy.isEmpty) return [];

  final String searchUrl = Uri.encodeFull(
      "https://google.com/complete/search?output=toolbar&client=firefox&q=$base");

  final http.Response response = await http.get(Uri.parse(config.corsProxy.value.format([searchUrl])));

  if (response.statusCode > 200) return null;

  final Iterable<dynamic> ls = jsonDecode(response.body) as Iterable<dynamic>;
  if (ls.isEmpty) return null;

  final List<String> found = (ls.toList()[1] as List<dynamic>).map((e) => e.toString()).toList();
  return _sanitizeSuggestions(base, found.length > size ? found.sublist(0, size) : found);
}

List<List<SearchResult>> _sanitizeSuggestions(final String input, final List<String> suggestions) => suggestions.map((e) {
  final List<SearchResult> parts = [];

  String curr = "";
  bool matches = false;
  for(int i = 0; i < e.length; i++) {
    if(i < input.length && input[i].toUpperCase() == e[i].toUpperCase()) {
      if(!matches) {
        parts.add((matches: false, part: curr));
        matches = true;
        curr = "";
      }

      curr += input[i];
      continue;
    }

    if(matches) {
      parts.add((matches: true, part: curr));
      matches = false;
      curr = "";
    }

    curr += e[i];
  }

  parts.add((matches: matches, part: curr));
  return parts;
}).toList();