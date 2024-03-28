// Function to copy the provided code to the clipboard after adding a preffix and suffix
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/data/database/service_provider_database.dart';

Future<void> copyCode(String code) async {
  // Check if the code is not empty
  if (code.isNotEmpty) {
    try {
      // Construct a refined code by adding prefix and suffix and removing whitespace
      String refinedCode =
          "${ServiceProvidersDatabase.safaricom.prefix}${code.trim()}#";

      // Use the clipboard package to copy the code to the clipboard
      await FlutterClipboard.copy(refinedCode);
    } catch (e) {
      debugPrint('Error while copying code: $e');
      throw 'Failed to copy code to clipboard';
    }
  } else {
    throw 'Code is empty';
  }
}
