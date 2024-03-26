import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../utils/filter_utils.dart';

// Function to extract text from an image file using Google ML Vision
Future<String?> scanImageFile({
  required File imageFile, // Required input: image file
  required TextRecognizer textRecognizer, // Required input: text recognizer
}) async {
  InputImage inputImage = InputImage.fromFile(imageFile);

  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

  String? extractedText = filter(recognizedText);

  return extractedText; // Return the extracted text
}
