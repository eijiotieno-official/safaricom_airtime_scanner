import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/data/database/service_providers_database.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

import 'grant_permissions.dart';

/// Function to send a USSD code and return the response.
Future<String?> sendUssd(String code) async {
  try {
    // Grant permissions required for sending USSD codes
    await grantPermissions();

    // Construct refined code by adding prefix, suffix, and removing whitespace
    String refinedCode = "${ServiceProvidersDatabase.safaricom.prefix}$code#"
        .replaceAll(" ", "");

    // Send the advanced USSD code and wait for the response
    return await UssdAdvanced.sendAdvancedUssd(code: refinedCode);
  } catch (e) {
    // Handle any exceptions that occur during USSD sending
    debugPrint('Error sending USSD: $e');
    return null; // Return null to indicate failure
  }
}
