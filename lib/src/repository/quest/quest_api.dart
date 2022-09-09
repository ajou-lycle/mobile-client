import '../../data/model/quest.dart';

class QuestApi {
  // TODO: 현재 이용 가능한 퀘스트 가져오기 & 완료한 퀘스트 목록 전송하기
  Future<List<List<Quest>>> getAvailableQuest() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return availableQuest;
  }
}

List<List<Quest>> availableQuest = [
  [
    Quest(
        category: "walking",
        level: 0,
        needToken: 0,
        rewardToken: 1,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(days: 1)),
        goal: 100,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "walking",
        level: 1,
        needToken: 1,
        rewardToken: 2,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(days: 1)),
        goal: 1000,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "walking",
        level: 2,
        needToken: 2,
        rewardToken: 3,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(days: 1)),
        goal: 2000,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "walking",
        level: 3,
        needToken: 3,
        rewardToken: 5,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(days: 1)),
        goal: 3000,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "walking",
        level: 4,
        needToken: 5,
        rewardToken: 7,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(days: 1)),
        goal: 5000,
        needTimes: 1,
        achievement: 0),
  ],
  [
    Quest(
        category: "running",
        level: 0,
        needToken: 0,
        rewardToken: 1,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(minutes: 30)),
        goal: 3,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "running",
        level: 1,
        needToken: 1,
        rewardToken: 2,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(minutes: 30)),
        goal: 5,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "running",
        level: 2,
        needToken: 2,
        rewardToken: 3,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(minutes: 30)),
        goal: 7,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "running",
        level: 3,
        needToken: 3,
        rewardToken: 5,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(minutes: 30)),
        goal: 10,
        needTimes: 1,
        achievement: 0),
    Quest(
        category: "running",
        level: 4,
        needToken: 5,
        rewardToken: 7,
        startDate: DateTime.now(),
        finishDate: DateTime.now().add(const Duration(minutes: 30)),
        goal: 15,
        needTimes: 1,
        achievement: 0),
  ]
];
