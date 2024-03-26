import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:safaricom_airtime_scanner/ui/components/copy_button.dart';
import 'package:safaricom_airtime_scanner/ui/components/recharge_button.dart';

import '../../utils/filter_utils.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  String? _code;
  bool _shouldDetect = true;

  CameraController? _cameraController;
  void _initCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    setState(() {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    });

    await _cameraController?.initialize();

    await _cameraController?.startImageStream(
      (image) async {
        if (_shouldDetect) {
          RecognizedText? recognizedText = await _detect(image: image);
          if (mounted) {
            if (recognizedText != null) {
              setState(() {
                _code = filter(recognizedText);
              });
              _shouldDetect = false; // Pause detection for 2 seconds
              await Future.delayed(const Duration(seconds: 5));
              _shouldDetect = true; // Resume detection after 2 seconds
            }
          }
        }
      },
    );
  }

  // Function to extract text from an image file using Google ML Vision
  Future<RecognizedText?> _detect({required CameraImage image}) async {
    InputImage? inputImage = _inputImage(image: image);
    if (inputImage != null) {
      return await _textRecognizer.processImage(inputImage);
    } else {
      return null;
    }
  }

  InputImage? _inputImage({required CameraImage image}) {
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: _concatenatePlanes(image.planes),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the captured image if available
          _buildCameraPreview(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          if (_code != null) _buildResultText(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          _buildCodeButtons(),
        ],
      ),
    );
  }

  Widget _buildCodeButtons() => _code == null
      ? const SizedBox.shrink()
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RechargeButton(code: _code!),
            CopyButton(code: _code!),
          ],
        );

  // Widget to display the scanned result
  Widget _buildResultText() {
    return Text(
      _code!,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Widget to build the image preview
  Widget _buildCameraPreview() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: _cameraController != null
          ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
              child: CameraPreview(_cameraController!),
            )
          : const Center(
              child: CircularProgressIndicator(strokeCap: StrokeCap.round),
            ),
    ); // Return an empty container if no image is available
  }
}
