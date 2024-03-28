import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/data/database/service_providers_database.dart';

/// Function to copy the provided code to the clipboard after adding a prefix and suffix.
Future<void> copyCode(String code) async {
  // Check if the code is not empty
  if (code.isNotEmpty) {
    try {
      // Construct refined code by adding prefix and suffix and removing whitespace
      String refinedCode =
          "${ServiceProvidersDatabase.safaricom.prefix}${code.trim()}#";
      // Use the clipboard package to copy the code to the clipboard
      await FlutterClipboard.copy(
          refinedCode); // Asynchronous operation to copy code
    } catch (e) {
      // Handle any errors thrown during clipboard copying
      debugPrint('Error while copying code: $e');
      throw 'Failed to copy code to clipboard';
    }
  } else {
    // Handle case where the code is empty by throwing an error
    throw 'Code is empty';
  }
}
