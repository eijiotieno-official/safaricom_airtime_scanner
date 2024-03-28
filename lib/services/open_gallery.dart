import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Function to open the device gallery and select an image
Future<XFile?> openGallery() async {
  try {
    final ImagePicker imagePicker = ImagePicker();
    // Use the pickImage method to select an image from the device gallery
    return await imagePicker.pickImage(source: ImageSource.gallery);
  } catch (e) {
    // Handle any errors that occur during image selection
    debugPrint('Error selecting image: $e');
    return null;
  }
}
