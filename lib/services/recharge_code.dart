import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/send_ussd.dart';

/// Function to initiate a recharge using a USSD code and display the result in a dialog.
Future<void> rechargeCode(String code, BuildContext context) async {
  try {
    await sendUssd(code).then(
      (value) {
        if (value != null) {
          // If a response is received, show it in an AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Recharge'),
                content: Text(value),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  } catch (e) {
    // Handle any exceptions that occur during the sendUssd operation
    debugPrint('Error initiating recharge: $e');
    // Optionally, show an error dialog to the user
  }
}
