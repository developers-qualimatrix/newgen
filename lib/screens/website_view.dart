import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InsuranzeePosScreen extends StatefulWidget {
  const InsuranzeePosScreen({super.key});

  @override
  State<InsuranzeePosScreen> createState() => _InsuranzeePosScreenState();
}

class _InsuranzeePosScreenState extends State<InsuranzeePosScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Use a transparent background
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: You could use this to update a linear progress indicator
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors, e.g., show a snackbar for connectivity issues
            Get.snackbar(
              'Error',
              'Failed to load page. Please check your internet connection.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            if (mounted) {
              setState(() {
                _isLoading = false; // Stop loading on error
              });
            }
          },
        ),
      )
      // Load the specified URL
      ..loadRequest(Uri.parse('https://pos.insuranzee.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is a Stack to show a loading indicator on top of the webview
      body: SafeArea(
        child: Stack(
          children: [
            // The WebViewWidget is always in the stack but might be hidden by the loader
            WebViewWidget(controller: _controller),

            // Show a loading indicator in the center while the page is loading
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                   // You can customize the color to match your app's theme
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}