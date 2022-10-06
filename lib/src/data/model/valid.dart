class Valid {
  final List<bool> isPassList = List<bool>.empty(growable: true);

  bool validate() {
    for (var isPass in isPassList) {
      if (!isPass) {
        return false;
      }
    }

    return true;
  }
}
