import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/copy_code.dart';

class CopyButton extends StatefulWidget {
  final String code;
  const CopyButton({super.key, required this.code});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _isCoping = false;
  @override
  Widget build(BuildContext context) {
    return _isCoping
        ? const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          )
        : FilledButton.tonal(
            onPressed: () async {
              setState(() {
                _isCoping = true;
              });
              await copyCode(widget.code);
              setState(() {
                _isCoping = false;
              });
            },
            child: const Text("Copy"), // Display the button text
          );
  }
}
