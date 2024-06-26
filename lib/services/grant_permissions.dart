import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Function to request and handle permissions for accessing phone-related features.
Future<void> grantPermissions() async {
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
      } else if (statuses[Permission.phone] == PermissionStatus.denied) {
        // Handle the case where the user cancels the permission request
        throw 'Permission request cancelled by user';
      }
    }
  } catch (e) {
    // Provide a more descriptive error message for any exceptions that occur during permission handling
    debugPrint('Error granting permissions: $e');
    throw 'Failed to grant permissions: $e';
  }
}
