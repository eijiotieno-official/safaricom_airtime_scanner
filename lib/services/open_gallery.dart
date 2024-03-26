import 'package:image_picker/image_picker.dart'; // Import the image_picker package

// Function to capture an image using the device camera
Future<XFile?> openGallery() async {
  final ImagePicker imagePicker =
      ImagePicker(); // Create an instance of ImagePicker
  // Use the pickImage method to capture an image from the device camera
  // Specify the source as the camera and preferredCameraDevice as rear
  return await imagePicker.pickImage(
    source: ImageSource.gallery,
  );
}
