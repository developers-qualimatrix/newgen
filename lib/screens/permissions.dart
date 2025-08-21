import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  Future<void> _requestPermissions() async {
    // Request multiple permissions at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    // Check if both permissions are granted
    if (statuses[Permission.camera]!.isGranted) {
      // Navigate to the webview screen and remove this screen from the stack
      Get.offAllNamed('/webview');
    } else {
      // Show an error message if permissions are not granted
      Get.snackbar(
        'Permissions Required',
        'Camera and Storage access are necessary to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'To provide the best experience, we need access to your camera and photo library.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildPermissionTile(
                number: 1,
                title: 'Camera Access',
                subtitle: 'To capture and upload documents.',
              ),
              const SizedBox(height: 16),
              _buildPermissionTile(
                number: 2,
                title: 'Storage Access',
                subtitle: 'To select and upload files.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _requestPermissions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Grant Access',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required int number,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Circular halo in orange
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.3),
                ),
              ),
              // Yellow circular avatar with the number
              CircleAvatar(
                backgroundColor: Colors.yellow.shade700,
                radius: 18,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
