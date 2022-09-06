import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/bloc/quest/quest_event.dart';
import 'package:lycle/src/bloc/quest/quest_state.dart';

import '../../data/model/quest.dart';
import '../../repository/quest/quest_repository.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final QuestRepository questRepository;

  QuestBloc({required this.questRepository}) : super(QuestEmpty()) {
    on<GetQuest>(_mapGetQuestToState);
    on<AvailableQuest>(_mapAvailableQuestToState);
    on<ErrorQuest>(_mapErrorQuestToState);
  }

  QuestState get initialState => QuestEmpty();

  Future<void> _mapGetQuestToState(
      GetQuest event, Emitter<QuestState> emit) async {
    try {
      emit(QuestLoading());
      emit(QuestLoaded(questList: questRepository.availableQuests));
    } catch (e) {
      emit(QuestError(error: "get quest error"));
    }
  }

  Future<void> _mapAvailableQuestToState(
      AvailableQuest event, Emitter<QuestState> emit) async {
    try {
      if (state is QuestLoaded) {
        final questList = state.props[0] as List<List<Quest>>;
        emit(QuestUpdated(questList: questList));
        emit(QuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(QuestError(error: "update error"));
    }
  }

  Future<void> _mapErrorQuestToState(
      ErrorQuest event, Emitter<QuestState> emit) async {
    emit(QuestError(error: "update error"));
  }
}
