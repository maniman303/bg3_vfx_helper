import 'package:flutter/widgets.dart';

class StringHelper {
  static bool isNullOrWhitespace(String? value) {
    if (value == null || value == "") {
      return true;
    }

    for (final char in value.characters) {
      final charTrimmed = char.trim();

      if (charTrimmed != "") {
        return false;
      }
    }

    return true;
  }
}
