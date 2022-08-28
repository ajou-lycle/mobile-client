import 'dart:async';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: Stream for getting health data

class HealthHelper {
  late List<String> readTypes;
  late List<String> writeTypes;

  bool hasPermissions = false;

  HealthHelper._internal({required this.readTypes, required this.writeTypes})
      : assert(readTypes != List.empty(),
            ArgumentError("You must select health data types you wanna get.")),
        assert(writeTypes != List.empty(),
            ArgumentError("You must select health data types you wanna write"));

  /// Create the singleton instance with the given types and permissions.
  ///
  /// Throws an [AssertionError] if the list of String [readTypes] is empty or
  /// the list of String [writeTypes] is empty. Returns the singleton instance.
  factory HealthHelper(
          {required List<String> readTypes,
          required List<String> writeTypes}) =>
      HealthHelper._internal(readTypes: readTypes, writeTypes: writeTypes);

  /// Request this permissions of this types to HealthKit.
  ///
  /// Throws an [AssertionError] if the length of this [readTypes] and
  /// this [writeTypes] is *not* equal. Returns true when request is success.
  Future<bool> requestPermission() async {
    assert(
        readTypes.length == writeTypes.length,
        AssertionError(
            'The length of this types and this permissions must be equal.'));

    bool requested =
        await HealthKitReporter.requestAuthorization(readTypes, writeTypes);

    // if use WorkOut, uncomment
    // await Permission.activityRecognition.request();
    // await Permission.location.request();

    hasPermissions = requested;

    return hasPermissions;
  }
}
