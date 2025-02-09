/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

import '../../../the_deck_common.dart';

class MafiaGameBoard
    extends GameBoard<MafiaGameField, MafiaGameMove, MafiaGamePlayer> {
  MafiaGameBoard(MafiaGameField field, List<MafiaGamePlayer> players)
      : super(gameField: field, players: players);

  @override
  bool makeMove(MafiaGameMove move) {
    final moved = gameField.move(move);
    if (moved) {
      moves.add(move);
    }
    return moved;
  }

  MafiaGameBoard copyWith({MafiaGameField? gameField}) {
    return MafiaGameBoard(gameField ?? this.gameField, players);
  }

  Map<String, dynamic> toMap() {
    return {
      'gameField': gameField.toMap(),
      'players': players.map((p) => p.toMap()).toList(),
      'moves': moves.map((m) => m.toMap()).toList(),
    };
  }

  factory MafiaGameBoard.fromMap(Map<String, dynamic> map) {
    final players = List<MafiaGamePlayer>.from(
      map['players'].map((p) => MafiaGamePlayer.fromMap(p)),
    );
    final moves = List<MafiaGameMove>.from(
      map['moves'].map((m) => MafiaGameMove.fromMap(m)),
    );
    final gameBoard = MafiaGameBoard(
      MafiaGameField.fromMap(map['gameField']),
      players,
    );
    gameBoard.moves.addAll(moves);
    return gameBoard;
  }
}
