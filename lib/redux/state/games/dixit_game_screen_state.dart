/*
 *
 *  *
 *  * Created on 5 4 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

import 'base_game_screen_state.dart';

class DixitGameScreenState extends BaseGameScreenState<DixitGameBoard> {
  final int selectedCardIndex;
  final DixitGameRoundState? localRoundState;

  DixitGameBoard get board => room.board;

  DixitGameScreenState(
    String? userId,
    GameRoom<DixitGameBoard> room,
    this.selectedCardIndex,
    this.localRoundState,
  ) : super(userId, room);

  DixitGameScreenState copyWith({
    GameRoom<DixitGameBoard>? room,
    int? selectedCardIndex,
    DixitGameRoundState? localRoundState,
  }) {
    return DixitGameScreenState(
      userId,
      room ?? this.room,
      selectedCardIndex ?? this.selectedCardIndex,
      localRoundState ?? this.localRoundState,
    );
  }
}
