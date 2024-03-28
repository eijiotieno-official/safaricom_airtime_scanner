import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Function to request and handle permissions for accessig phone-related features
Future<void> grantUssdPermission() async {
  try {
    // Check if permissions are already granted
    final bool phoneGranted = await Permission.phone.isGranted;

    // If permissions are not granted, request them
    if (!phoneGranted) {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.phone].request();

      // If permissions are permanently denied, open app settings
      if (statuses[Permission.phone] == PermissionStatus.permanentlyDenied) {
        await openAppSettings(); // Open app settings to allow users to grant permissions
      }
    }
  } catch (e) {
    debugPrint('Error granting permissions: $e');
    throw 'Failed to grant permissions: $e';
  }
}
