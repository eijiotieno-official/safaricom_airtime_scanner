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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextRecognizer _textRecognizer =
      GoogleMlKit.vision.textRecognizer(); // TextRecognizer instance
  bool _isScanning = false; // Variable to track scanning state

  bool _isChecking = false;

  @override
  void dispose() {
    _textRecognizer.close(); // Close the TextRecognizer instance
    super.dispose();
  }

  String _code = "";
  // Function to start scanning the image
  void _startScanning() async {
    setState(() {
      _isScanning = true; // Set scanning state to true
    });
    final result = await scanImageFile(
      imageFile: File(_imageFile!.path),
      textRecognizer: _textRecognizer,
    ); // Perform the scanning operation
    if (result != null) {
      setState(() {
        _code = result;
      });
    }
    setState(() {
      _isScanning = false; // Set scanning state to false
    });
  }

  XFile? _imageFile;
  // Function to capture a new photo
  void _pickPhoto() async {
    if (_imageFile == null) {
      final pickedImage =
          await openGallery(); // Capture a new photo using the image picker
      setState(() {
        _imageFile = pickedImage; // Update the image file
      });
    } else {
      setState(() {
        _imageFile = null;
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
            _buildImagePreview(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _buildScanningIndicator(),
            _buildCodeButtons(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _pickPhoto,
              child: _imageFile != null
                  ? const Icon(Icons.camera_alt_rounded)
                  : const Icon(Icons.close_rounded),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
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

  // Widget to build the image preview
  Widget _buildImagePreview() {
    return _imageFile != null
        ? Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.file(File(_imageFile!.path)),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          )
        : Container(); // Return an empty container if no image is available
  }

  // Widget to build the scanning indicator or scan button
  Widget _buildScanningIndicator() {
    return _isScanning
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
                strokeCap: StrokeCap
                    .round), // Display a progress indicator while scanning
          )
        : _imageFile != null
            ? FilledButton.tonal(
                onPressed: () async {
                  _startScanning(); // Start scanning the image
                },
                child: const Text("Scan"), // Display a scan button
              )
            : Container(); // Return an empty container if no image is available
  }

  Widget _buildCodeButtons() => _code.isEmpty
      ? const SizedBox.shrink()
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RechargeButton(code: _code),
            CopyButton(code: _code),
          ],
        );
}
