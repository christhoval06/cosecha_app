import 'package:flutter/material.dart';

class AppSheetLayout extends StatelessWidget {
  const AppSheetLayout({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.headerSpacing = 8,
    this.onClose,
    this.titleStyle,
    this.scrollableContent = false,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final double headerSpacing;
  final VoidCallback? onClose;
  final TextStyle? titleStyle;
  final bool scrollableContent;

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final content = Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: padding.add(EdgeInsets.only(bottom: safeBottom)),
        child: Column(
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style:
                        titleStyle ?? Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ?trailing,
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: headerSpacing),
            if (scrollableContent)
              Expanded(child: SingleChildScrollView(child: content))
            else
              ...children,
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppSheet<T>({
  required BuildContext context,
  required String title,
  required List<Widget> Function(BuildContext context) contentBuilder,
  Widget? Function(BuildContext context)? trailingBuilder,
  bool isScrollControlled = false,
  bool useSafeArea = true,
  MainAxisSize mainAxisSize = MainAxisSize.min,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  double headerSpacing = 8,
  bool scrollableContent = false,
  EdgeInsetsGeometry Function(BuildContext context)? paddingBuilder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    builder: (context) {
      return AppSheetLayout(
        title: title,
        trailing: trailingBuilder?.call(context),
        padding:
            paddingBuilder?.call(context) ??
            const EdgeInsets.fromLTRB(16, 12, 16, 16),
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        headerSpacing: headerSpacing,
        scrollableContent: scrollableContent,
        children: contentBuilder(context),
      );
    },
  );
}
