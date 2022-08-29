class Steps {
  int currentSteps = 0;
  final DateTime startAt;
  late final DateTime finishAt;

  Steps({required this.startAt}) {
    finishAt = startAt.add(const Duration(days: 1));
  }

  static Steps byTodaySteps() {
    final now = DateTime.now();

    return Steps(startAt: DateTime(now.year, now.month, now.day));
  }
}
