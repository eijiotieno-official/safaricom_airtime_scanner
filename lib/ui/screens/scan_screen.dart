import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:safaricom_airtime_scanner/ui/components/copy_button.dart';
import 'package:safaricom_airtime_scanner/ui/components/recharge_button.dart';
import 'package:safaricom_airtime_scanner/utils/filter_utils.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;

  // Function to initialize the camera and start image stream
  void _initCamera() async {
    // Get available cameras
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
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

            if (mounted && recognizedText != null) {
              setState(() {
                _extractedCode = filter(recognizedText);
              });
              _shouldDetect = false;
              await Future.delayed(
                  const Duration(seconds: 5)); // Pause detection for 5 seconds
              _shouldDetect = true;
            }
          }
        },
      );
    }
  }

  bool _shouldDetect = true;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  String? _extractedCode;

  // Function to extract text from an image using Google Ml Vision
  Future<RecognizedText?> _detect({required CameraImage image}) async {
    InputImage? inputImage = _inputImage(image: image);

    if (inputImage != null) {
      return await _textRecognizer.processImage(inputImage);
    } else {
      return null;
    }
  }

  // Function to convert CameraImage to InputImage
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

  // Function to concatenate planes of CameraImage
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
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display camera preview
          _buildCameraPreview(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buidlExtractedCode(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildCodeButtons(), // Display recharge and copy buttons if code is extracted
        ],
      ),
    );
  }

  Widget _buildCodeButtons() {
    return _extractedCode == null
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Button to recharge with extracted code
              RechargeButton(code: _extractedCode!),
              // Button to copy extracted code
              CopyButton(code: _extractedCode!),
            ],
          );
  }

  Widget _buildCameraPreview() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: _cameraController != null
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CameraPreview(_cameraController!),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
              ),
            ),
    );
  }

  Widget _buidlExtractedCode() {
    return _extractedCode == null
        ? const SizedBox.shrink()
        : Text(
            _extractedCode!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          );
  }
}

// NOTE: Use a real device, emulators fail to download the models responsible for recognizing the text.