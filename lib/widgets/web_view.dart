import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewApp extends StatelessWidget {
  const WebviewApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const WebAppScreen();
  }
}

class WebAppScreen extends StatefulWidget {
  const WebAppScreen({super.key});
  @override
  State<WebAppScreen> createState() => _WebAppScreenState();
}

class _WebAppScreenState extends State<WebAppScreen> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return const Text("Hello");
  }
}
