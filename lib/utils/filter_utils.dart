import 'package:google_ml_kit/google_ml_kit.dart';

/// Function to filter and extract valid text from recognized text.
String? filter(RecognizedText recognizedText) {
  String? extractedText;

  // Loop through each block of text in the recognized text
  for (TextBlock block in recognizedText.blocks) {
    final String blockText = block.text;

    // Check if the block text is valid
    if (isValidText(blockText)) {
      extractedText = blockText;
      break;
    }

    // Loop through each line of text in the block
    for (TextLine line in block.lines) {
      final String lineText = line.text;

      // Check if the line text is valid
      if (isValidText(lineText)) {
        extractedText = lineText;
        break;
      }

      // Loop through each element of text in the line
      for (TextElement element in line.elements) {
        final String elementText = element.text;

        // Check if the element text is valid
        if (isValidText(elementText)) {
          extractedText = elementText;
          break;
        }
      }
    }

    if (extractedText != null) {
      break; // Exit the loop if extractedText is not null
    }
  }

  return extractedText;
}

/// Function to check if the text is valid based on certain criteria.
bool isValidText(String? text) {
  return text != null &&
      text.isNotEmpty &&
      containsWhiteSpace(text) &&
      !containsHyphen(text) &&
      !containsAlphabeticCharacters(text);
}

/// Function to check if the text contains whitespace characters.
bool containsWhiteSpace(String text) {
  return RegExp(r'\s').hasMatch(text);
}

/// Function to check if the text contains a hyphen character.
bool containsHyphen(String text) {
  return text.contains('-');
}

/// Function to check if the text contains alphabetic characters.
bool containsAlphabeticCharacters(String text) {
  return RegExp(r'[a-zA-Z]').hasMatch(text);
}
