import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import '../../model/quest.dart';

/// Helper for health kit reporter.
///
/// You extends this class when you must declare *explicit type* of list type in child constructor like this...
/// ```dart
/// QuantityHealthHelper._internal(
///       {required List<QuantityType> readTypes,
///       required List<QuantityType> writeTypes})
///       : super._internal(readTypes, writeTypes) {
///     _readTypesIdentifiers = List<String>.generate(
///         readTypes.length, (index) => readTypes[index].identifier);
///     _writeTypesIdentifiers = List<String>.generate(
///         writeTypes.length, (index) => writeTypes[index].identifier);
///         // something you want ...
///   }
/// ```
///
/// Throws an [ArgumentError] if the list [_readTypes] is empty or
/// the list [_writeTypes] is empty or the runtimeType of both are not equal.

abstract class IOSHealthHelper {
  late List _readTypes;
  late List _writeTypes;
  late List<String> _readTypesIdentifiers;
  late List<String> _writeTypesIdentifiers;

  bool _hasPermissions = false;
  int _deniedCount = 0;
  num _timeStamp = 0;

  IOSHealthHelper._internal(this._readTypes, this._writeTypes)
      : assert(
            _readTypes.runtimeType == _writeTypes.runtimeType,
            ArgumentError(
                "You must declare same type for readTypes and writeTypes"));

  bool get hasPermissions => _hasPermissions;

  /// Request this permissions of this types to HealthKit.
  Future<void> requestPermission() async {
    assert(_readTypes.isNotEmpty || _writeTypes.isNotEmpty,
        "The both of permission can *not* be empty.");
    bool requested = await HealthKitReporter.requestAuthorization(
        _readTypesIdentifiers, _writeTypesIdentifiers);

    print("request Permission $requested");

    // if use WorkOut, uncomment
    // await Permission.activityRecognition.request();
    // await Permission.location.request();

    _hasPermissions = requested;
  }

  /// Get StreamSubscription of HealthKit data updated.
  ///
  /// Throws an [AssertionError] if [_hasPermissions] is false or
  /// [predicate.startDate] is *not* before [predicate.endDate].
  /// The parameter of [onUpdate] is identifier of HealthKit data type.
  void _observerQuery(Predicate predicate, Function(String) onUpdate) async {
    assert(_hasPermissions, "You don't have permissions");
    assert(predicate.startDate.isBefore(predicate.endDate),
        "The start time must be before end time.");

    HealthKitReporter.observerQuery(_readTypesIdentifiers, predicate,
        onUpdate: onUpdate);

    for (final identifier in _readTypesIdentifiers) {
      await HealthKitReporter.enableBackgroundDelivery(
          identifier, UpdateFrequency.immediate);
    }
  }
}

class QuantityIOSHealthHelper extends IOSHealthHelper {
  QuantityIOSHealthHelper._internal(
      {required List<QuantityType> readTypes,
      required List<QuantityType> writeTypes})
      : super._internal(readTypes, writeTypes) {
    _readTypesIdentifiers = List<String>.generate(
        readTypes.length, (index) => readTypes[index].identifier);
    _writeTypesIdentifiers = List<String>.generate(
        writeTypes.length, (index) => writeTypes[index].identifier);
  }

  /// Create the singleton instance with the given types and permissions.
  ///
  /// Throws an [AssertionError] if the list of String [readTypes] is empty or
  /// the list of String [writeTypes] is empty. Returns the singleton instance.
  factory QuantityIOSHealthHelper(
          {required List<QuantityType> readTypes,
          required List<QuantityType> writeTypes}) =>
      QuantityIOSHealthHelper._internal(
          readTypes: readTypes, writeTypes: writeTypes);

  set readTypes(List<QuantityType> value) {
    _readTypes = value;
    _readTypesIdentifiers = List<String>.generate(
        readTypes.length, (index) => readTypes[index].identifier);
  }

  set writeTypes(List<QuantityType> value) {
    _writeTypes = value;
    _writeTypesIdentifiers = List<String>.generate(
        _writeTypes.length, (index) => writeTypes[index].identifier);
  }

  List<QuantityType> get readTypes => _readTypes as List<QuantityType>;

  List<QuantityType> get writeTypes => _writeTypes as List<QuantityType>;

  /// Get StreamSubscription of the quantity of HealthKit data updated. You can handle it with callback.
  ///
  /// Throws an [AssertionError] if the DateTime [start] is *not* before [end].
  /// The parameter of [acceptCallback] is the quantity, num, of HealthKit data updated.
  void observerQueryForQuantityQuery(
      List<Quest> questList,
      List<void Function(num)> acceptCallbackList,
      List<void Function(int)> deniedCallbackList) {
    if (questList.isEmpty) {
      return;
    }

    Predicate predicate =
        Predicate(DateTime.now(), DateTime.now().add(const Duration(days: 1)));

    _observerQuery(predicate, (identifier) async {
      try {
        final preferredUnits = await HealthKitReporter.preferredUnits(
            _readTypes as List<QuantityType>);

        await Future.forEach(preferredUnits,
            (PreferredUnit preferredUnit) async {
          final identifier = preferredUnit.identifier;
          final unit = preferredUnit.unit;
          final type = QuantityTypeFactory.from(identifier);

          for (int index = 0; index < questList.length; index++) {
            for (QuantityType questType in questList[index].types) {
              if (type == questType) {
                try {
                  Predicate questPredicate = Predicate(
                      questList[index].startDate, questList[index].finishDate);
                  final quantities = await HealthKitReporter.quantityQuery(
                      type, unit, questPredicate);

                  num result = 0;

                  for (Quantity data in quantities) {
                    bool isDataAllowed =
                        (data.startTimestamp != data.endTimestamp) &&
                                (data.device?.name != null ||
                                    data.device?.manufacturer != null)
                            ? true
                            : false;

                    if (isDataAllowed) {
                      result += data.harmonized.value;
                    } else {
                      bool isAlreadyDenied =
                          _timeStamp >= data.startTimestamp ? true : false;

                      if (isAlreadyDenied) {
                        continue;
                      } else {
                        _timeStamp = data.startTimestamp;
                        _deniedCount += 1;

                        deniedCallbackList[index](_deniedCount);

                        if (int.parse(dotenv.env['DENIED_COUNT']!) ==
                            _deniedCount) {
                          _deniedCount = 0;
                        }

                        return;
                      }
                    }
                  }

                  acceptCallbackList[index](result);
                } catch (e) {
                  // TODO: Error type 정하기
                  print(e);
                }
              }
            }
          }
        });
      } catch (e) {
// TODO: Error type 정하기
        print(e);
      }
    });
  }
}
