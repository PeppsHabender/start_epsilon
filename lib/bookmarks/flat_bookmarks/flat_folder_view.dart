part of 'flat_bookmark_view.dart';

class _FlatFolderView extends StatelessWidget {
  final int depth;
  final Nested nested;
  late final List<IComponent> bookmarks;

  final List<String> merged = [];
  late final Color? avgColor;

  _FlatFolderView(this.depth, this.nested) {
    bookmarks = merge(nested);
    avgColor = averageColor(bookmarks.whereType<Bookmark>().map((e) => e.primaryColor).whereType<Color>());
  }

  List<IComponent> merge(final Nested nested) {
    if(nested.children.length == 1 && nested.children[0] is Nested) {
      merged.add(nested.children[0].id);
      return merge(nested.children[0] as Nested);
    }

    return List.of(nested.children)..sort(FlatBookmarkView.compare);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: double.infinity,
        child: _folderHeader(context)
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          _bookmarks(),
          const SizedBox(height: 15),
          Column(children: bookmarks.whereType<Nested>().map((e) => _FlatFolderView(depth + 1, e)).toList())
        ],
      ),
    ],
  );

  Widget _folderHeader(final BuildContext context) => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: context.theme.scaffoldBackgroundColor.darker(.07).withAlpha(150),
          blurStyle: BlurStyle.inner
        ),
        BoxShadow(
          color: context.theme.scaffoldBackgroundColor.darker(.04).withAlpha(150),
          spreadRadius: -3,
          blurRadius: 5,
        ),
      ]
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0 * depth).add(const EdgeInsets.symmetric(vertical: 10)),
      child: Row(
        children: [
          Text(nested.id, style: TextStyle(fontSize: 25.0 - (depth * 0.3), color: avgColor)),
          ...merged.map((e) => Text(e, style: TextStyle(fontSize: 25.0 - (depth * 0.3))))
              .expand((e) => [Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(">", style: TextStyle(fontSize: 25.0 - (depth * 0.3), color: context.theme.colorScheme.primary)),
          ), e])
        ],
      ),
    )
  );

  Widget _bookmarks() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.0 * depth),
    child: Wrap(
      spacing: 15,
      children: bookmarks.whereType<Bookmark>().map((e) => NeonBookmarkView(e)).toList(),
    ),
  );
}