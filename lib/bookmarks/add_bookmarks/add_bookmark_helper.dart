part of 'add_bookmark.dart';

Widget _coloredWidget(Widget Function(Color) builder) => Get.find<IConfig>().generalConfig.primaryColor.ReadOnlyWidget(
  (globalPrim) => Get.find<AddBookmarkController>().primaryColor.ReadOnlyWidget((color) => builder(color ?? globalPrim))
);

Widget _neonBorder(final BuildContext context) => Positioned.fill(
  child: _coloredWidget((color) => IgnorePointer(
    child: Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.darker(0.02),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: color, blurRadius: 5, blurStyle: BlurStyle.outer)]
      ),
    )),
  )
);

Widget _header(final BuildContext context) => Align(
  alignment: Alignment.centerLeft,
  child: _coloredWidget(
    (color) => Text("New Bookmark",
      style: context.textTheme.headlineMedium?.copyWith(color: color)
    ),
  )
);

Widget _idTextfield() => FocusColorChangingTextFormField(
  color: Get.find<AddBookmarkController>().displayColor,
  validator: (v) => v == null || v.isEmpty ? "Id may not be empty" : null,
  labelText: "Enter identifier for your bookmark (Use '>' to separate into folders)",
  controller: Get.find<AddBookmarkController>().idController
);

Widget _urlIconEditor(final BuildContext context) => Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Expanded(child: _urlTextfield()),
    InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => _pickIcon(context),
      child: Obx(
        () {
          final IconData? icon = Get.find<AddBookmarkController>().selectedIcon.value;
          final String? url = Get.find<AddBookmarkController>().iconUrl.value.value;

          if(icon == null) {
            return _favIconDisplay(context, url ?? "");
          }

          return SizedBox(
            width: 50,
            height: 50,
            child: RxGlowIcon(
              icon,
              color: Get.find<AddBookmarkController>().displayColor,
              size: 30
            )
          );
        }
      ),
    )
  ],
);

Widget _urlTextfield() => FocusColorChangingTextFormField(
  color: Get.find<AddBookmarkController>().displayColor,
  validator: (v) => v == null || v.isEmpty ? "Url may not be empty" : null,
  labelText: "Enter url of the bookmark",
  controller: Get.find<AddBookmarkController>().urlController,
  onChanged: (_) => Get.find<AddBookmarkController>().resetTimer()
);

Widget _favIconDisplay(final BuildContext context, final String url) => ImageNetwork(
  key: Key(url),
  image: url,
  height: 50,
  width: 50,
  debugPrint: true,
  onTap: () => _pickIcon(context),
  onLoading: const SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
  onError: Tooltip(
    message: "Failed to fetch icon for the given url..",
    child: RxGlowIcon(
      Icons.add_circle_outline,
      color: Get.find<AddBookmarkController>().displayColor,
      size: 30
    )
  ),
);

void _pickIcon(final BuildContext context) async => Get.find<AddBookmarkController>().selectedIcon.value = await showIconPicker(
  context,
  title: const Text("Pick an icon to display, or deselect..."),
  iconPackModes: [IconPack.lineAwesomeIcons],
  closeChild: const Text("Deselect"),
  iconPickerShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
);

Widget _additionalSettings() => Column(
  children: [
    _newTabToggle(),
    const SizedBox(height: 10),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Primary color of the bookmark"),
          _colorPicker(),
        ],
      ),
    )
  ],
);

Widget _newTabToggle() => Row(
  children: [
    Obx(() => Checkbox(
      value: Get.find<AddBookmarkController>().openInNewTab.value,
      onChanged: (b) => Get.find<AddBookmarkController>().openInNewTab.value = b ?? true,
      activeColor: Get.find<AddBookmarkController>().displayColor.value
    )),
    const Text("Open bookmark in new tab?")
  ],
);

Widget _colorPicker() => InkWell(
  onTap: () => Get.dialog(
    Center(
      child: Card(
        child: BlockPicker(
          pickerColor: Get.find<AddBookmarkController>().displayColor.value,
          onColorChanged: (color) {
            Get.find<AddBookmarkController>().primaryColor.value = color;
            Get.back(closeOverlays: true);
          },
        ),
      ),
    )
  ),
  child: _colorPickerContent()
);

Widget _colorPickerContent() => _coloredWidget(
  (color) => Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
        color: color,
        blurStyle: BlurStyle.outer,
        blurRadius: 3
        )
      ]
    ),
  )
);

Widget _submitButton(final BuildContext context, final GlobalKey<FormState> formKey, final void Function() close) {
  final AddBookmarkController controller = Get.find();

  return Align(
    alignment: Alignment.centerRight,
    child: _coloredWidget(
      (color) => OutlinedButton(
        onPressed: () {
          if(formKey.currentState?.validate() == false) {
            return;
          }

          controller.addBookmark();
          controller.reset();

          close();
        },
        style: OutlinedButton.styleFrom(side: BorderSide(color: color)),
        child: Text(controller.addText, style: TextStyle(color: context.theme.colorScheme.onSurface))
      ),
    ),
  );
}