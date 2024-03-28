import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/recharge_code.dart';

/// Widget representing a button to recharge using a code.
class RechargeButton extends StatefulWidget {
  final String code;

  /// Constructor for the RechargeButton widget.
  const RechargeButton({super.key, required this.code});

  @override
  State<RechargeButton> createState() => _RechargeButtonState();
}

class _RechargeButtonState extends State<RechargeButton> {
  bool _isRecharging = false; // Track whether recharging is in progress

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isRecharging
          ? null // Disable the button while recharging is in progress
          : () async {
              setState(() {
                _isRecharging = true; // Set recharging state to true
              });
              // Recharge the code asynchronously
              await rechargeCode(widget.code, context);
              setState(() {
                _isRecharging = false; // Reset recharging state to false
              });
            },
      // Display the button text
      child: _isRecharging
          ? CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary),
            )
          : const Text("Recharge"),
    );
  }
}
