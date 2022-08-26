class Steps {
  int? previousSteps;
  int? currentSteps;
  DateTime startAt;
  DateTime finishAt;

  Steps({required this.startAt}) {
    finishAt = startAt.add(const Duration(days: 1));
  }
}