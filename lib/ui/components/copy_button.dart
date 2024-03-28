import 'package:flutter/material.dart';
import 'package:safaricom_airtime_scanner/services/copy_code.dart';

/// Widget representing a button to copy a code.
class CopyButton extends StatefulWidget {
  final String code;

  /// Constructor for the CopyButton widget.
  const CopyButton({super.key, required this.code});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _isCopying = false; // Track whether copying is in progress

  @override
  Widget build(BuildContext context) {
    return _isCopying
        ? const CircularProgressIndicator(strokeCap: StrokeCap.round)
        : FilledButton.tonal(
            onPressed: _isCopying
                ? null // Disable the button while copying is in progress
                : () async {
                    setState(() {
                      _isCopying = true; // Set copying state to true
                    });
                    // Copy the code asynchronously
                    await copyCode(widget.code);
                    setState(() {
                      _isCopying = false; // Reset copying state to false
                    });
                  },
            // Display the button text
            child: const Text("Copy"),
          );
  }
}
