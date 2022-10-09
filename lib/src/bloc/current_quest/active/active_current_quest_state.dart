import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ActiveCurrentQuestState extends Equatable {}

class ActiveCurrentQuestEmpty extends ActiveCurrentQuestState {
  @override
  List<Object?> get props => [];
}

class ActiveCurrentQuestLoading extends ActiveCurrentQuestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ActiveCurrentQuestError extends ActiveCurrentQuestState {
  final String? error;

  ActiveCurrentQuestError({this.error});

  @override
  String toString() => 'ActiveCurrentQuestError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ActiveCurrentQuestLoaded extends ActiveCurrentQuestState {
  final Quest quest;

  ActiveCurrentQuestLoaded({required this.quest});

  @override
  String toString() => 'ActiveCurrentQuestLoaded { quest: $quest }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class ActiveCurrentQuestUpdated extends ActiveCurrentQuestState {
  final Quest quest;

  ActiveCurrentQuestUpdated({required this.quest});

  @override
  String toString() => 'ActiveCurrentQuestUpdated { quest: $quest }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class ActiveCurrentQuestAchieved extends ActiveCurrentQuestState {
  final Quest quest;

  ActiveCurrentQuestAchieved({required this.quest});

  @override
  String toString() => 'ActiveCurrentQuestAchieved { quest: $quest }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class ActiveCurrentQuestDenied extends ActiveCurrentQuestState {
  final Quest quest;
  final bool isDenied = false;

  ActiveCurrentQuestDenied({required this.quest});

  @override
  String toString() =>
      'ActiveCurrentQuestDenied { quest: $quest, isDenied: $isDenied }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest, isDenied];
}
