import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safaricom_airtime_scanner/services/scan_image_file.dart';
import 'package:safaricom_airtime_scanner/ui/components/copy_button.dart';
import 'package:safaricom_airtime_scanner/ui/components/recharge_button.dart';
import 'package:safaricom_airtime_scanner/ui/screens/scan_screen.dart';
import '../../services/open_gallery.dart';

/// Widget representing the home screen of the app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  bool _isScanning = false;
  String _extractedCode = "";
  XFile? _imageFile;

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // Function to start scanning the image
  void _startScanning() async {
    setState(() {
      _isScanning = true; // Set scanning state to true
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
      // Handle any errors that occur during scanning
      debugPrint('Error scanning image: $e');
      // Optionally, provide feedback to the user
    }
    setState(() {
      _isScanning = false; // Set scanning state to false
    });
  }

  // Function to pick a new photo or clear the existing one
  void _pickPhoto() async {
    if (_imageFile == null) {
      final pickedImage = await openGallery(); // Pick a new photo
      setState(() {
        _imageFile = pickedImage; // Update the image file
      });
    } else {
      setState(() {
        _imageFile = null; // Clear the existing photo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _buildScanningIndicator(), // Display scanning indicator or scan button
            _buildCodeButtons(), // Display recharge and copy buttons if code is extracted
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "pick",
              onPressed: _pickPhoto, // Pick a new photo or clear existing one
              child: _imageFile == null
                  ? const Icon(Icons.camera_alt_rounded)
                  : const Icon(Icons.close_rounded),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: "scan",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScanScreen(); // Navigate to the scan screen
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

  // Widget to build the image preview
  Widget _buildImagePreview() {
    return _imageFile != null
        ? SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.file(File(_imageFile!.path)),
          )
        : const Text(
            "Pick a photo"); // Prompt to pick a photo if none is selected
  }

  // Widget to build the scanning indicator or scan button
  Widget _buildScanningIndicator() {
    return _isScanning
        // Display a progress indicator while scanning
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeCap: StrokeCap.round),
          )
        : _imageFile != null
            // Display a scan button if an image is selected
            ? ElevatedButton(
                onPressed: _startScanning,
                child: const Text("Scan"),
              )
            : Container(); // Return an empty container if no image is selected
  }

  // Widget to build the recharge and copy buttons
  Widget _buildCodeButtons() => _extractedCode.isEmpty
      ? const SizedBox.shrink()
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RechargeButton(
                code: _extractedCode), // Button to recharge with extracted code
            CopyButton(code: _extractedCode), // Button to copy extracted code
          ],
        );
}
