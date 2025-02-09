/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:thedeck_common/the_deck_common.dart';

class MafiaGameScreenState {
  //User ID is null if it is a Deck only
  final String? userId;
  final GameRoom<MafiaGameBoard> room;
  final bool showRoleVisible;
  final int? selectedPlayerCarouselIndex;

  MafiaGameBoard get board => room.board;

  MafiaGameScreenState(
    this.userId,
    this.room,
    this.showRoleVisible,
    this.selectedPlayerCarouselIndex,
  );

  MafiaGameScreenState copyWith({
    GameRoom<MafiaGameBoard>? room,
    bool? showRoleVisible,
    int? selectedPlayerCarouselIndex,
  }) {
    return MafiaGameScreenState(
      userId,
      room ?? this.room,
      showRoleVisible ?? this.showRoleVisible,
      selectedPlayerCarouselIndex ?? this.selectedPlayerCarouselIndex,
    );
  }

  MafiaGameScreenState copyRemovePlayer({
    GameRoom<MafiaGameBoard>? room,
    bool? showRoleVisible,
  }) {
    return MafiaGameScreenState(
      userId,
      room ?? this.room,
      showRoleVisible ?? this.showRoleVisible,
      null,
    );
  }
}
