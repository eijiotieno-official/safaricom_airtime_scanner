import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/recharge_code.dart';

class RechargeButton extends StatefulWidget {
  final String code;
  const RechargeButton({super.key, required this.code});

  @override
  State<RechargeButton> createState() => _RechargeButtonState();
}

class _RechargeButtonState extends State<RechargeButton> {
  // Track whether recharging is in progress
  bool _isRecharging = false;

  @override
  Widget build(BuildContext context) {
    return _isRecharging
        ? const CircularProgressIndicator(strokeCap: StrokeCap.round)
        : FilledButton.tonal(
            onPressed: () async {
              setState(() {
                _isRecharging = true;
              });

              // Recharge the code
              await rechargeCode(widget.code, context);

              setState(() {
                _isRecharging = false;
              });
            },
            child: const Text("Copy"),
          );
  }
}
