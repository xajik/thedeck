/*
 *
 *  *
 *  * Created on 19 5 2023
 *
 */

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';

void main() {
  test('newField should create a new game field with correct initial state',
      () {
    // Create a sample game field for testing
    final players = [
      DixitGamePlayer('player1'),
      DixitGamePlayer('player2'),
      DixitGamePlayer('player3'),
    ];
    final gameField = DixitGameField.newField(players);
    // Verify the initial state of the game field
    expect(
        gameField.handCards.length, equals(3)); // Check the number of players
    expect(
        gameField.roundState,
        equals(DixitGameRoundState
            .storytellerChoosingCard)); // Check the initial round state
    expect(gameField.isGameOver, isFalse); // Game is not over
    expect(gameField.gameScore, isEmpty); // No scores yet
  });
}
