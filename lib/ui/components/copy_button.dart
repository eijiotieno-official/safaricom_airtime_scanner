import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/copy_code.dart';

class CopyButton extends StatefulWidget {
  final String code;
  const CopyButton({super.key, required this.code});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  // Track whether copying is in progress
  bool _isCopying = false;

  @override
  Widget build(BuildContext context) {
    return _isCopying
        ? const CircularProgressIndicator(strokeCap: StrokeCap.round)
        : FilledButton.tonal(
            onPressed: () async {
              setState(() {
                _isCopying = true;
              });

              // Copy the code
              await copyCode(widget.code);

              setState(() {
                _isCopying = false;
              });
            },
            child: const Text("Copy"),
          );
  }
}
