import 'dart:math';

import 'package:animated_path/animated_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark_controller.dart';
import 'package:start_page/bookmarks/flat_bookmarks/flat_bookmark_view.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/main/main_page.dart';
import 'package:start_page/search/search_bar.dart';
import 'package:start_page/utils/extensions.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'dart:ui' as ui;

import 'config/config_impl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    theme: ThemeData.light(useMaterial3: true),
    darkTheme: ThemeData.dark(useMaterial3: true),
    initialBinding: StartPageBindings(),
    initialRoute: "/",
    getPages: [GetPage(name: "/", page: () => MainPage())],
  );
}

class StartPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IConfig>(() => StartPageConfig());
    Get.lazyPut(() => AddBookmarkController());
    IBookmarkService.bind();
  }
}