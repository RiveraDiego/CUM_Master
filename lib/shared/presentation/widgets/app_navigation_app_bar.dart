import 'package:flutter/material.dart';

PreferredSizeWidget appNavigationAppBar(
  BuildContext context, {
  required Widget title,
  List<Widget> actions = const [],
}) {
  final navigator = Navigator.of(context);
  final canGoBack = navigator.canPop();
  return AppBar(
    title: title,
    leading: canGoBack ? BackButton(onPressed: navigator.maybePop) : null,
    actions: [
      ...actions,
      if (canGoBack)
        Builder(
          builder: (buttonContext) => IconButton(
            tooltip: MaterialLocalizations.of(
              buttonContext,
            ).openAppDrawerTooltip,
            onPressed: () => Scaffold.of(buttonContext).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
    ],
  );
}
