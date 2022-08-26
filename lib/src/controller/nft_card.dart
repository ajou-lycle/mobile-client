import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class NFTCardController<T extends Object> extends ValueNotifier {
  NFTCardController(super.value);

  // TODO: ValueListenable<T>를 return 하기
  ValueListenable getController(NFTCardController nftCardController) =>
      nftCardController;
}

class NFTCardIndexController extends NFTCardController<int> {
  NFTCardIndexController(super.value);

  void onIndexChanged({required int index}) {
    value = index;
    notifyListeners();
  }
}
