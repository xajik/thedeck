/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 31 2023
 */

import '../encodable/encodable_json.dart';

abstract class GameBoard<T extends GameField, Y extends GameMove,
    R extends GamePlayer> extends JsonEncodeable {
  final List<Y> moves = List.empty(growable: true);
  final T gameField;
  final List<R> players;
  R? winner;

  GameBoard({required this.gameField, required this.players});

  bool makeMove(Y move);

  @override
  Map<String, dynamic> toMap() {
    return {
      'moves': moves.map((move) => move.toMap()).toList(),
      'gameField': gameField.toMap(),
      'players': players.map((player) => player.toMap()).toList(),
      'winner': winner?.toMap()
    };
  }
}

abstract class GameField extends JsonEncodeable {
  bool isGameOver = false;

  @override
  Map<String, dynamic> toMap() {
    return {
      'isGameOver': isGameOver,
    };
  }
}

abstract class GameMove extends JsonEncodeable {
  final String userId;

  GameMove(this.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }
}

abstract class GamePlayer extends JsonEncodeable {
  final String userId;

  GamePlayer(this.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is GamePlayer && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}
