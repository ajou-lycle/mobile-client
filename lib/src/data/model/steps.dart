abstract class Steps {
  int currentSteps = 0;
  final DateTime startAt;
  late final DateTime finishAt;

  Steps({required this.startAt}) {
    finishAt = startAt.add(const Duration(days: 1));
  }
}

class QuestSteps extends Steps {
  final int goal;

  QuestSteps({required this.goal, required DateTime startAt})
      : super(startAt: startAt);

  static QuestSteps byTodaySteps(int goal) {
    final now = DateTime.now();

    return QuestSteps(
        goal: goal, startAt: DateTime(now.year, now.month, now.day));
  }
}
