// Function to initiate a recharge using a USSD code andsiplay the result in a dialog
import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/send_ussd.dart';

Future<void> rechargeCode(String code, BuildContext context) async {
  try {
    // send USSD code
    await sendUssd(code).then(
      (value) {
        if (value != null) {
          // If a reponse if received, show it in an AlertDialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Recharge"),
                content: Text(value),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text("Close"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  } catch (e) {
    debugPrint('Error initiating recharge: $e');
  }
}
