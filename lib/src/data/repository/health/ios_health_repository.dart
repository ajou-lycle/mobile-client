import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../helper/health/ios_health_helper.dart';
import '../../model/quest.dart';

class IOSHealthRepository {
  final List<List<QuantityType>> readTypesList = List.empty(growable: true);
  final List<List<QuantityType>> writeTypesList = List.empty(growable: true);
  final List<void Function(num)> acceptCallbackList =
      List<void Function(num)>.empty(growable: true);
  final List<void Function(int)> deniedCallbackList =
      List<void Function(int)>.empty(growable: true);

  final List<QuantityType> _eliminateDuplicateReadTypes =
      List<QuantityType>.empty(growable: true);
  final List<QuantityType> _eliminateDuplicateWriteTypes =
      List<QuantityType>.empty(growable: true);
  late QuantityIOSHealthHelper _quantityIOSHealthHelper;

  IOSHealthRepository() {
    _quantityIOSHealthHelper = QuantityIOSHealthHelper(
        readTypes: _eliminateDuplicateReadTypes,
        writeTypes: _eliminateDuplicateWriteTypes);
  }

  Future<void> requestPermission() async {
    _setPermissionOfHelper();

    await _quantityIOSHealthHelper.requestPermission();
  }

  void observerQueryForQuantityQuery(List<Quest> questList) {
    _setPermissionOfHelper();

    _quantityIOSHealthHelper.observerQueryForQuantityQuery(
        questList, acceptCallbackList, deniedCallbackList);
  }

  void addAccessAuthority(
      {required List<QuantityType> readTypes,
      required List<QuantityType> writeTypes,
      void Function(num)? acceptCallback,
      void Function(int)? deniedCallback}) {
    readTypesList.add(readTypes);
    writeTypesList.add(writeTypes);

    if (acceptCallback == null) {
      acceptCallbackList.add((count) {});
    } else {
      acceptCallbackList.add(acceptCallback);
    }

    if (deniedCallback == null) {
      deniedCallbackList.add((count) {});
    } else {
      deniedCallbackList.add(deniedCallback);
    }
  }

  void deleteAccessAuthority({required List<QuantityType> readTypes}) {
    int index = readTypesList.indexOf(readTypes);
    readTypesList.removeAt(index);
    writeTypesList.removeAt(index);
    acceptCallbackList.removeAt(index);
    deniedCallbackList.removeAt(index);
  }

  void _setPermissionOfHelper() {
    for (List<QuantityType> readTypes in readTypesList) {
      for (QuantityType readType in readTypes) {
        if (!_eliminateDuplicateReadTypes.contains(readType)) {
          _eliminateDuplicateReadTypes.add(readType);
        }
      }
    }

    for (List<QuantityType> writeTypes in writeTypesList) {
      for (QuantityType writeType in writeTypes) {
        if (!_eliminateDuplicateWriteTypes.contains(writeType)) {
          _eliminateDuplicateWriteTypes.add(writeType);
        }
      }
    }

    _quantityIOSHealthHelper.readTypes = _eliminateDuplicateReadTypes;
    _quantityIOSHealthHelper.writeTypes = _eliminateDuplicateWriteTypes;
  }
}
