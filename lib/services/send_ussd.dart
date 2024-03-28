// Function to send a USSD code and return the response
import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/data/database/service_provider_database.dart';
import 'package:safaricom_airtime_scanner/services/grant_ussd_permission.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

Future<String?> sendUssd(String code) async {
  try {
    // Grant permission required for sending USSD code
    await grantUssdPermission();

    // Construct a refined code by adding prefix and suffix and removing whitespace
    String refinedCode =
        "${ServiceProvidersDatabase.safaricom.prefix}${code.trim()}#";

    // Send the advanced USSD code and wait for the response
    return await UssdAdvanced.sendAdvancedUssd(code: refinedCode);
  } catch (e) {
    debugPrint('Error sending USSD: $e');
    return null;
  }
}
