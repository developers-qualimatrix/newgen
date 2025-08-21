import 'dart:io'; // Required for checking the platform (Android/iOS)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // For handling file uploads
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// You need this for the modern implementation.

class InsuranzeePosScreen extends StatefulWidget {
  const InsuranzeePosScreen({super.key});

  @override
  State<InsuranzeePosScreen> createState() => _InsuranzeePosScreenState();
}

class _InsuranzeePosScreenState extends State<InsuranzeePosScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  // Use a flag to ensure the controller is ready before building the WebViewWidget.
  bool _isWebViewInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    await _requestAppPermissions();

    // The fromPlatformCreationParams initialization is correct.
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isAndroid) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    // Now, configure the controller using the correct methods.
    if (Platform.isAndroid) {
      final androidController = _controller.platform as AndroidWebViewController;

      // This handles runtime permissions like camera and microphone.
      await androidController.setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) {
          request.grant();
        },
      );

      // This handles the file picker for the gallery, which was correct.
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }

    // Set up the rest of the controller and load the URL.
    await _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            Get.snackbar(
              'Important',
              'If the page does not load, please restart the application.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://pos.insuranzee.com/'));

    // Set the flag to true and rebuild the widget.
    if (mounted) {
      setState(() {
        _isWebViewInitialized = true;
      });
    }
  }

  // *** MODIFIED FUNCTION TO SHOW CAMERA/GALLERY CHOICE ***
  // This function now presents a choice to the user.
  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    // We need the context to show the modal sheet, so we check if the widget is mounted.
    if (!mounted) return [];

    final picker = ImagePicker();
    XFile? photo;

    // Show a bottom sheet with options.
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  photo = await picker.pickImage(source: ImageSource.camera);
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  photo = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );

    // If the user picked a file, return its path.
    if (photo != null) {
      return [Uri.file(photo!.path).toString()];
    } else {
      // If the user cancelled, return an empty list.
      return [];
    }
  }

  Future<void> _requestAppPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Use the initialization flag to decide when to build the WebView.
            if (_isWebViewInitialized)
              WebViewWidget(controller: _controller)
            else
              const Center(child: CircularProgressIndicator()),
            // The loading indicator for the page itself remains the same.
            if (_isLoading && _isWebViewInitialized)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}