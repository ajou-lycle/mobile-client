import 'package:flutter/material.dart';

extension DeprecatedCheck on BuildContext {
  /// Check context is deprecated.
  bool isDeprecated() {
    return toString().contains("(DEFUNCT)(no widget)");
  }
}
