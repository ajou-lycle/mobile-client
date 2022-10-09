import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../enum/quest_data_type.dart';
import '../../helper/health/ios_health_helper.dart';
import '../../model/quest.dart';

class IOSHealthRepository {
  final List<QuestDataType> questDataTypeList =
      List<QuestDataType>.empty(growable: true);
  List<void Function(QuantityType, num)> acceptCallbackList =
      List<void Function(QuantityType, num)>.empty(growable: true);

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
    cancelStreamSubscription();

    if (_eliminateDuplicateReadTypes.isEmpty &&
        _eliminateDuplicateWriteTypes.isEmpty) {
      return;
    }

    for (int index = 0; index < questList.length; index++) {
      QuestDataType questDataType = QuestDataType.getByCategory(questList[index].category);
      if(questDataType != questDataTypeList[index]) {
        int dest = questDataTypeList.indexOf(questDataType);

        var tempQuestDataType = questDataTypeList[index];
        var tempAcceptCallback = acceptCallbackList[index];

        questDataTypeList[index] = questDataTypeList[dest];
        acceptCallbackList[index] = acceptCallbackList[dest];

        questDataTypeList[dest] = tempQuestDataType;
        acceptCallbackList[dest] = tempAcceptCallback;
      }
    }

    _quantityIOSHealthHelper.observerQueryForQuantityQuery(
        questList, acceptCallbackList);
  }

  void deleteAccessAuthority({required QuestDataType questDataType}) {
    int index = questDataTypeList.indexOf(questDataType);
    questDataTypeList.removeAt(index);
    acceptCallbackList.removeAt(index);
  }

  void cancelStreamSubscription() {
    if (_quantityIOSHealthHelper.streamSubscription != null) {
      _quantityIOSHealthHelper.streamSubscription?.cancel();
      _quantityIOSHealthHelper.streamSubscription = null;
    }
  }

  void _setPermissionOfHelper() {
    for (QuestDataType questDataType in questDataTypeList) {
      for (QuantityType readType in questDataType.readTypes) {
        if (!_eliminateDuplicateReadTypes.contains(readType)) {
          _eliminateDuplicateReadTypes.add(readType);
        }
      }
      for (QuantityType writeType in questDataType.writeTypes) {
        if (!_eliminateDuplicateWriteTypes.contains(writeType)) {
          _eliminateDuplicateWriteTypes.add(writeType);
        }
      }
    }

    _quantityIOSHealthHelper.readTypes = _eliminateDuplicateReadTypes;
    _quantityIOSHealthHelper.writeTypes = _eliminateDuplicateWriteTypes;
  }
}
