/*
 *
 *  *
 *  * Created on 20 5 2023
 *  
 */

import 'dart:math';

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

void main() {
  test('Create new game room', () {
    GameRoom<ConnectFourGameBoard> room = _createRoom();
    expect(room, isNotNull);

    var move = room?.board.gameField.makeMove(0, true);
    expect(move, true);

    move = room?.board.gameField.makeMove(0, true);
    expect(move, false);

    move = room?.board.gameField.makeMove(0, false);
    expect(move, true);

    move = room?.board.gameField.makeMove(0, false);
    expect(room?.board.winner, isNull);
  });

  test('Game winner test', () {
    GameRoom<ConnectFourGameBoard> room = _createRoom();
    expect(room, isNotNull);

    for (var i = 0; i < 4; i++) {
      var move = room!.board.gameField.makeMove(0, true);
      expect(move, true);
      move = room.board.gameField.makeMove(0, true);
      expect(move, false);
      if (i < 3) {
        expect(room.board.gameField.isGameOver, false);
        move = room.board.gameField.makeMove(1, false);
        expect(move, true);
      } else {
        expect(room.board.gameField.isGameOver, true);
        move = room.board.gameField.makeMove(1, false);
        expect(move, false);
      }
    }
  });
}

GameRoom<ConnectFourGameBoard> _createRoom() {
  final field = ConnectFourGameField();
  final random = Random();
  final isYellow = random.nextBool();
  final participants = [_createParticipant(true), _createParticipant(false)];
  final players = [
    ConnectFourGamePlayer.fromParticipant(participants[0], isYellow),
    ConnectFourGamePlayer.fromParticipant(participants[1], !isYellow)
  ];
  final bord = ConnectFourGameBoard(gameField: field, players: players);
  GameRoom<ConnectFourGameBoard> room = GameRoom(
    roomVersion: 1,
    roomId: Ulid().toString(),
    participants: participants,
    details: GamesList.connectFour.details,
    board: bord,
  );
  return room;
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
