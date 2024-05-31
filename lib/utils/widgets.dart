import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start_page/utils/extensions.dart';

class Expandable extends StatelessWidget {
  final Rx<Color?> color;
  final Widget child;
  final String title;
  final RxBool expanded = false.obs;

  Expandable({required this.title, required this.child, Rx<Color?>? color, super.key}) : color = color ?? Rx(null as Color?);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        onTap: expanded.toggle,
        hoverColor: Colors.transparent,
        child: Row(
          children: [
            color.ReadOnlyWidget((color) => Text(title, style: TextStyle(color: color))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: color.ReadOnlyWidget((color) => Divider(color: color, thickness: 1.5)),
              ),
            ),
            color.ReadOnlyWidget(
              (color) => expanded.ReadOnlyWidget(
                (value) => value ? Icon(Icons.keyboard_arrow_up, color: color) : Icon(Icons.keyboard_arrow_down, color: color)
              )
            )
          ],
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: expanded.ReadOnlyWidget(
          (value) => value ? child : const SizedBox()
        ),
      )
    ],
  );
}

class RxGlowIcon extends StatelessWidget {
  final IconData icon;
  final Rx<Color?> color;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool? applyTextScaling;

  const RxGlowIcon(this.icon, {
    required this.color,
    super.key,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
  });

  @override
  Widget build(BuildContext context) => color.ReadOnlyWidget((color) => Icon(
    icon,
    color: color,
    size: size,
    fill: fill,
    weight: weight,
    grade: grade,
    opticalSize: opticalSize,
    semanticLabel: semanticLabel,
    textDirection: textDirection,
    applyTextScaling: applyTextScaling,
    shadows: [BoxShadow(color: color ?? context.iconColor!, blurRadius: 3)],
  ));
}

class FocusColorChangingTextFormField extends StatelessWidget {
  final Rx<Color?> color;
  final String? Function(String? v)? validator;
  final void Function(String? v)? onChanged;
  final String? labelText;
  final TextEditingController? controller;

  final RxBool _focused = false.obs;
  final FocusNode _focusNode = FocusNode();

  FocusColorChangingTextFormField({
    required this.color,
    this.validator,
    this.onChanged,
    this.labelText,
    this.controller,
    super.key
  }) {
    _focusNode.addListener(() => _focused.value = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => TextFormField(
      focusNode: _focusNode,
      validator: validator,
      onChanged: onChanged,
      controller: controller ?? TextEditingController(),
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: color.value == null
            ? null
            : UnderlineInputBorder(borderSide: BorderSide(color: color.value!)),
        labelStyle: TextStyle(color: _focused.value ? color.value : null)
      )
    )
  );
}