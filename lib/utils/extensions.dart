import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef RxReadOnlyBuilder<T> = Widget Function(T value);
typedef RxReadWriteBuilder<T> = Widget Function(
  T value,
  void Function(T) write
);
typedef RxReadAddRemBuilder<T> = Widget Function(
  List<T> value,
  void Function(T) add,
  void Function(T) remove
);

extension NullStringExtensions on String? {
  String? concat(String other) => this == null ? null : this! + other;
}

extension RxExtensions<T> on Rx<T> {
  Widget ReadOnlyWidget(RxReadOnlyBuilder<T> builder, {Key? key}) =>
      ObxValue((v) => builder(v.value), this, key: key);

  Widget ReadWriteWidget(RxReadWriteBuilder<T> builder, {Key? key}) =>
      ObxValue((v) => builder(v.value, (newV) => value = newV), this, key: key);
}

extension RxListExtensions<T> on RxList<T> {
  Widget ReadOnlyWidget(Widget Function(List<T>) builder, {Key? key}) =>
      ObxValue((v) => builder(v), this, key: key);

  Widget ReadAddRemWidget(RxReadAddRemBuilder<T> builder, {Key? key}) =>
      ObxValue((value) => builder(List.unmodifiable(value), add, remove), this, key: key);
}

extension IterableExtensions<T> on Iterable<T> {
  Map<A, B> associateBy<A, B>((A, B) Function(T e) associator) =>
    Map.fromEntries(map(associator).map((e) => MapEntry(e.$1, e.$2)));

  Map<A, List<T>> groupBy<A>(A Function(T) keyExtractor) => fold(
    <A, List<T>>{},
    (map, e) => map..putIfAbsent(keyExtractor(e), () => <T>[]).add(e)
  );

  Map<A, List<B>> groupByWith<A, B>(
  A Function(T) keyExtractor, B Function(T) valueExtractor) => fold(
    <A, List<B>>{},
    (map, e) => map..putIfAbsent(keyExtractor(e), () => <B>[]).add(valueExtractor(e))
  );

  Iterable<A> mapIndexed<A>(A Function(int idx, T e) mapper) => indexed.map((e) => mapper(e.$1, e.$2));

  T? reduceOrNull(T Function(T value, T element) combine) => isEmpty ? null : reduce(combine);

  void forEachIndexed(void Function(int idx, T e) action) => indexed.forEach((e) => action(e.$1, e.$2));
}

extension ColorExensions on Color {
  Color darker([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighter([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}