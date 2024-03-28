import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../utils/filter_utils.dart';

/// Function to extract text from an image file using Google ML Vision.
Future<String?> scanImageFile({
  required File imageFile, // Required input: image file
  required TextRecognizer textRecognizer, // Required input: text recognizer
}) async {
  try {
    // Convert the image file to an InputImage
    InputImage inputImage = InputImage.fromFile(imageFile);

    // Process the image to extract text using the textRecognizer
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Filter the extracted text if needed
    String? extractedText = filter(recognizedText);

    return extractedText; // Return the extracted text
  } catch (e) {
    // Handle any exceptions that occur during image processing
    debugPrint('Error scanning image: $e');
    return null; // Return null to indicate failure
  }
}
