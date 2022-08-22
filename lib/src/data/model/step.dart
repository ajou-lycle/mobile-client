class Step {
  int? previousSteps;
  int? currentSteps;
  DateTime startAt;
  DateTime finishAt;

  Step({required this.startAt}) {
    finishAt = startAt.add(const Duration(days: 1));
  }
}