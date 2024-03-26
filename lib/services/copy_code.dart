import 'dart:async'; // Import the async library for asynchronous operations
import 'package:clipboard/clipboard.dart';
import 'package:safaricom_airtime_scanner/data/database/service_providers_database.dart'; // Import the clipboard package

// Function to copy the provided code to the clipboard
Future<void> copyCode(String code) async {
  // Check if the code is not empty
  if (code.isNotEmpty) {
    // Use the clipboard package to copy the code to the clipboard
    String refinedCode = "${ServiceProvidersDatabase.safaricom.prefix}$code#"
        .replaceAll(" ", "");
    await FlutterClipboard.copy(
        refinedCode); // Asynchronous operation to copy code
  } else {
    // Handle case where the code is empty by throwing an error
    throw 'code is empty';
  }
}
