import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safaricom_airtime_scanner/services/open_gallery.dart';
import 'package:safaricom_airtime_scanner/services/scan_image_file.dart';
import 'package:safaricom_airtime_scanner/ui/components/copy_button.dart';
import 'package:safaricom_airtime_scanner/ui/components/recharge_button.dart';
import 'package:safaricom_airtime_scanner/ui/screens/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function to pick a new photo or clear the existing one
  XFile? _imageFile;
  void _pickPhoto() async {
    if (_imageFile == null) {
      // Pick a new photo
      final pickedImage = await openGallery();
      setState(() {
        _imageFile = pickedImage; // Update the image file
      });
    } else {
      setState(() {
        _imageFile = null; // Clear the existing image file
      });
    }
  }

  bool _isScanning = false;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  String _extractedCode = "";

  void _startScanning() async {
    setState(() {
      _isScanning = true;
    });

    try {
      // Perform the scanning operation
      final result = await scanImageFile(
        imageFile: File(_imageFile!.path),
        textRecognizer: _textRecognizer,
      );

      if (result != null) {
        setState(() {
          _extractedCode = result; // Store the extracted code
        });
      }
    } catch (e) {
      debugPrint('Error scanning image: $e');

      // Optionally, provide feedback to the user
    }

    setState(() {
      _isScanning = false;
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Give the app's status and navigation bar a uniform color to the app background color
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Safaricom Airtime Scanner"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImagePreview(), // Display the selected image or prompt to pick one
            SizedBox(height: MediaQuery.of(context).size.height * 0.5),
            // Display scanning indicator or scan button
            _buildScanningIndicatorOrButton(),
            // Display recharge and copy buttons if the code is extracted
            _buildCodeButtons(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "pick",
              onPressed: _pickPhoto,
              child: _imageFile == null
                  ? const Icon(Icons.camera_alt_rounded)
                  : const Icon(Icons.close_rounded),
            ),
            FloatingActionButton(
              heroTag: "scan",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScanScreen();
                    },
                  ),
                );
              },
              child: const Icon(Icons.document_scanner_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return _imageFile != null
        ? SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.file(File(_imageFile!.path)),
          )
        : const Text("Pick an image");
  }

  Widget _buildScanningIndicatorOrButton() {
    return _isScanning
        ?
        // Display a progress indicator while scanning
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          )
        : _imageFile != null
            ? FilledButton.tonal(
                onPressed: _startScanning,
                child: const Text("Scan"),
              )
            : const SizedBox.shrink();
  }

  Widget _buildCodeButtons() {
    return _extractedCode.isEmpty
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Button to recharge with extracted code
              RechargeButton(code: _extractedCode),
              // Button to copy extracted code
              CopyButton(code: _extractedCode),
            ],
          );
  }
}
