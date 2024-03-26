import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/recharge_code.dart';

class RechargeButton extends StatefulWidget {
  final String code;
  const RechargeButton({super.key, required this.code});

  @override
  State<RechargeButton> createState() => _RechargeButtonState();
}

class _RechargeButtonState extends State<RechargeButton> {
  bool _isRecharging = false;
  @override
  Widget build(BuildContext context) {
    return _isRecharging
        ? const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          )
        : FilledButton.tonal(
            onPressed: () async {
              setState(() {
                _isRecharging = true;
              });
              await rechargeCode(widget.code, context);
              setState(() {
                _isRecharging = false;
              });
            },
            child: const Text("Recharge"), // Display the button text
          );
  }
}
