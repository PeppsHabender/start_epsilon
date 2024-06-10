import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/bookmarks/add_bookmarks/add_bookmark_controller.dart';
import 'package:start_page/config/bookmarks.dart';
import 'package:start_page/config/config.dart';
import 'package:start_page/main/main_page.dart';

import 'config/config_impl.dart';

void main() {
  document.onContextMenu.listen((event) => event.preventDefault());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    theme: ThemeData.light(useMaterial3: true),
    darkTheme: ThemeData.dark(useMaterial3: true),
    initialBinding: EpsilonBindings(),
    initialRoute: "/",
    getPages: [GetPage(name: "/", page: () => MainPage())],
  );
}

class EpsilonBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IConfig>(() => StartPageConfig());
    Get.lazyPut(() => AddBookmarkController());
    IBookmarkService.bind();
  }
}