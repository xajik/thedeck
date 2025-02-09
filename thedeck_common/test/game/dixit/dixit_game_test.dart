/*
 *
 *  *
 *  * Created on 4 4 2023
 *
 */

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';

void main() {
  group('DixitGameBoard', () {
    late DixitGameBoard board;
    late DixitGameField field;
    late List<DixitGamePlayer> players;

    setUp(() {
      final player1 = DixitGamePlayer('player_1');
      final player2 = DixitGamePlayer('player_2');
      final player3 = DixitGamePlayer('player_3');
      players = [player1, player2, player3];
      field = DixitGameField.newField(players);
      board = DixitGameBoard(gameField: field, players: players);
    });

    test('should have a valid initial state', () {
      expect(board.gameField, equals(field));
      expect(board.players, equals(players));
      expect(board.winner, isNull);
    });

    test('should update game state after a valid move', () {
      //Storyteller select card
      expect(field.roundState, DixitGameRoundState.storytellerChoosingCard);
      final storyTellerUserId = field.storyteller;
      var move = DixitGameMove(storyTellerUserId, _getDixitGameCard(1));
      expect(board.makeMove(move), isTrue);

      //Players select card
      expect(field.roundState, DixitGameRoundState.playersChoosingCard);

      for (int i = 0; i < players.length; i++) {
        var player = players[i];
        if (storyTellerUserId != player.userId) {
          move = DixitGameMove(player.userId, _getDixitGameCard(i + 2));
          expect(board.makeMove(move), isTrue);
          expect(board.makeMove(move), isFalse);
        }
      }
      expect(field.roundState, DixitGameRoundState.playersVote);

      //Players vote
      for (int i = 0; i < players.length; i++) {
        var player = players[i];
        if (storyTellerUserId != player.userId) {
          move = DixitGameMove(player.userId, _getDixitGameCard(i + 1));
          expect(board.makeMove(move), isTrue);
          expect(board.makeMove(move), isFalse);
        }
      }

      expect(field.roundState, DixitGameRoundState.roundEnded);

      field.gameScore.forEach((key, value) {
        print("Player: $key, Score: $value");
      });

      move = DixitGameMove(storyTellerUserId, []);
      expect(board.makeMove(move), isTrue);

      expect(field.roundState, DixitGameRoundState.storytellerChoosingCard);
    });
  });
}

_getDixitGameCard([int id = 100]) =>
    List.of([DixitGameCard(id, "text", "url")]);
