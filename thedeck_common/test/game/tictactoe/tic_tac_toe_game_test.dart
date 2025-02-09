/*
 *
 *  *
 *  * Created on 12 2 2023
 *
 */

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

void main() {
    manualCreationEndToEndTest();
}


void manualCreationEndToEndTest() {
  test('Create Room', () {
    final gameDetails = GamesList.ticTacToe.details;
    final roomId = Ulid().toUuid();
    final host = _createParticipant(true);
    final client = _createParticipant(false);
    final field = TicTacToeGameField();
    final playerCross = TicTacToeGamePlayer.fromParticipant(host, true);
    final playerZero = TicTacToeGamePlayer.fromParticipant(client, false);
    final players = [playerCross, playerZero];
    final bord = TicTacToeGameBoard(field, players);
    final room = GameRoom<TicTacToeGameBoard>.start(
        roomId: roomId, details: gameDetails, board: bord);

    //Test participant joining the room
    expect(true, room.join(host));
    expect(false, room.join(host));

    expect(true, room.join(client));
    expect(false, room.join(client));

    testRoom(room, playerCross.userId, playerZero.userId);
  });
}

void testRoom(
  GameRoom<TicTacToeGameBoard> room,
  String playerCrossId,
  String playerZeroId,
) {
  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(0, 0))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    false,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(0, 0))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    false,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(1, 0))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerZeroId, Pair.of(2, 2))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(0, 1))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerZeroId, Pair.of(0, 2))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(1, 1))),
  );

  expect(false, room.board.gameField.isGameOver);

  expect(
    true,
    room.board.makeMove(TicTacToeGameMove(playerZeroId, Pair.of(1, 2))),
  );

  expect(true, room.board.gameField.isGameOver);

  expect(
    false,
    room.board.makeMove(TicTacToeGameMove(playerCrossId, Pair.of(1, 0))),
  );
}

GameParticipant _createParticipant(bool isHost) {
  return GameParticipant(
    userId: Ulid().toUuid(),
    sessionId: Ulid().toUuid(),
    isHost: isHost,
    profile: ParticipantProfile(
      nickname: Ulid().toUuid(),
      image: "https://default.com",
      score: 100,
    ),
  );
}
