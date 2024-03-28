// Function to extract text from an image file using Google Ml Vision
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:safaricom_airtime_scanner/utils/filter_utils.dart';

Future<String?> scanImageFile({
  required File imageFile,
  required TextRecognizer textRecognizer,
}) async {
  try {
    // Convert the image file to an InputImage
    InputImage inputImage = InputImage.fromFile(imageFile);

    // Process the image to extract text using the textRecognizer
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Filter the extracted text to return only the Scratch Card Code
    String? extractedText = filter(recognizedText);

    return extractedText;
  } catch (e) {
    debugPrint('Error scanning image: $e');
    return null;
  }
}
