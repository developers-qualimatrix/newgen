import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey(); // Generate unique key to rebuild the widget

  void restartApp() {
    setState(() {
      key = UniqueKey(); // Trigger a complete rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
