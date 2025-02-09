/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:redux/redux.dart';
import 'package:collection/collection.dart';
import 'package:the_deck/redux/actions/game/redux_actions_mafia_game.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/games/mafia/redux_middleware_mafia_game_client.dart';
import '../base_game_view_model.dart';

class MafiaViewModel extends BaseGameViewModel {
  final MafiaGameField? gameField;
  final String? userId;
  final List<MafiaGamePlayer> players;
  final List<GameParticipant> participants;
  final Function makeTurn;
  final bool showRoleVisible;
  final Function() toggleShowRole;
  final int? selectedPlayerCarousel;
  final Function(int?) carouselSelectPlayer;

  late final player = players.firstWhereOrNull((e) => e.userId == userId);
  late final participant =
      participants.firstWhereOrNull((e) => e.userId == userId);

  @override
  get isGameOver => gameField?.isGameOver ?? false;

  MafiaViewModel(
    this.gameField,
    this.userId,
    this.makeTurn,
    this.players,
    this.participants,
    this.showRoleVisible,
    this.toggleShowRole,
    this.selectedPlayerCarousel,
    this.carouselSelectPlayer,
    Store<AppState> store,
  ) : super(store);

  factory MafiaViewModel.create(Store<AppState> store) {
    final screenState = store.state.mafiaGameScreenState;
    final participants = screenState?.room.participants ?? [];
    final field = screenState?.board.gameField;
    final userId = screenState?.userId;
    final players = screenState?.board.players ?? [];
    final selectedPlayerCarousel = screenState?.selectedPlayerCarouselIndex;

    makeTurn() {
      if (userId != null &&
          field?.round.alivePlayers.contains(userId) == true) {
        final player =
            screenState?.board.players.firstWhere((e) => e.userId == userId);
        String? target;
        if (selectedPlayerCarousel != null &&
            selectedPlayerCarousel >= 0 &&
            selectedPlayerCarousel <= (field?.alivePlayers.length ?? 0) - 1) {
          target = field?.alivePlayers.elementAt(selectedPlayerCarousel);
        }
        final move = MafiaGameMove(
          userId,
          target ?? userId,
          player?.role.ability,
        );
        store.dispatch(middlewareMafiaClientMove(move));
      }
    }

    carouselSelectPlayer(int? index) {
      store.dispatch(MafiaGameSelectedPlayerAction(index));
    }

    final showRoleVisible = screenState?.showRoleVisible ?? false;
    toggleShowRole() {
      store.dispatch(MafiaGameToggleShowRoleAction(!showRoleVisible));
    }

    return MafiaViewModel(
      field,
      userId,
      makeTurn,
      players,
      participants,
      showRoleVisible,
      toggleShowRole,
      selectedPlayerCarousel,
      carouselSelectPlayer,
      store,
    );
  }
}
