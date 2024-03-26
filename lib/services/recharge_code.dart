import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/send_ussd.dart';

Future<void> rechargeCode(String code, BuildContext context) async {
  await sendUssd(code).then(
    (value) {
      if (value != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Recharge'),
              content: Text(value),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
}
