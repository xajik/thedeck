/*
 *
 *  *
 *  * Created on 31 7 2023
 *  
 */

import 'dart:math';

import 'package:test/test.dart';

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/src/room/builder/mafia_game_room_builder.dart';
import 'package:ulid/ulid.dart';

void main() {
  test('Test Mafia Room Builder', () {
    final room = MafiaGameRoomBuilder(false);
    expect(room.isReady(), false);
    final p = List.generate(
      MafiaConst.minParticipants - 1,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      room.addParticipant(e);
    });
    expect(room.isReady(), false);
    room.addParticipant(_createParticipant(false));
    expect(room.isReady(), true);
    expect(room.start(), isNotNull);
  });

  test('Test Mafia Room Builder with 5 players - 2x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      MafiaConst.minParticipantsWithDoctor,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    final Map<MafiaPlayerRole, Set<String>> roles = {};
    room?.board.players.forEach((e) {
      (roles[e.role] ??= Set()).add(e.userId);
    });

    expect(roles[MafiaPlayerRole.mafia]?.length, 1);
    expect(roles[MafiaPlayerRole.detective]?.length, 1);
    expect(roles[MafiaPlayerRole.doctor]?.length, 1);
    expect(roles[MafiaPlayerRole.lawyer]?.length, isNull);
    expect(roles[MafiaPlayerRole.citizen]?.isNotEmpty, true);

    final gamePlayers = roles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, p.length);
  });

  test('Test Mafia Room Builder with 6 players - 1x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      MafiaConst.minParticipantsWithDoctor + 1,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    final Map<MafiaPlayerRole, Set<String>> roles = {};
    room?.board.players.forEach((e) {
      (roles[e.role] ??= Set()).add(e.userId);
    });

    expect(roles[MafiaPlayerRole.mafia]?.length, 1);
    expect(roles[MafiaPlayerRole.detective]?.length, 1);
    expect(roles[MafiaPlayerRole.doctor]?.length, 1);
    expect(roles[MafiaPlayerRole.lawyer]?.length, isNull);
    expect(roles[MafiaPlayerRole.citizen]?.isNotEmpty, true);

    final gamePlayers = roles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, p.length);
  });

  test('Test Mafia Room Builder with 7 players - 2x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      MafiaConst.minParticipantsAllPlayers,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    final Map<MafiaPlayerRole, Set<String>> roles = {};
    room?.board.players.forEach((e) {
      (roles[e.role] ??= Set()).add(e.userId);
    });

    expect(roles[MafiaPlayerRole.mafia]?.length, 2);
    expect(roles[MafiaPlayerRole.detective]?.length, 1);
    expect(roles[MafiaPlayerRole.doctor]?.length, 1);
    expect(roles[MafiaPlayerRole.lawyer]?.length, 1);
    expect(roles[MafiaPlayerRole.citizen]?.isNotEmpty, true);

    final gamePlayers = roles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, p.length);
  });

  test('Test Mafia Room Builder with 10 players - 3x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      10,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    final Map<MafiaPlayerRole, Set<String>> roles = {};
    room?.board.players.forEach((e) {
      (roles[e.role] ??= Set()).add(e.userId);
    });

    expect(roles[MafiaPlayerRole.mafia]?.length, 3);
    expect(roles[MafiaPlayerRole.detective]?.length, 1);
    expect(roles[MafiaPlayerRole.doctor]?.length, 1);
    expect(roles[MafiaPlayerRole.lawyer]?.length, 1);
    expect(roles[MafiaPlayerRole.citizen]?.isNotEmpty, true);

    final gamePlayers = roles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, p.length);
  });

  test('Test Mafia Room Builder with 15 players - 5x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      MafiaConst.maxParticipants,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    final Map<MafiaPlayerRole, Set<String>> roles = {};
    room?.board.players.forEach((e) {
      (roles[e.role] ??= Set()).add(e.userId);
    });

    expect(roles[MafiaPlayerRole.mafia]?.length, 5);
    expect(roles[MafiaPlayerRole.detective]?.length, 1);
    expect(roles[MafiaPlayerRole.doctor]?.length, 1);
    expect(roles[MafiaPlayerRole.lawyer]?.length, 1);
    expect(roles[MafiaPlayerRole.citizen]?.isNotEmpty, true);

    final gamePlayers = roles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, p.length);
  });

  test('Test Room Game Over with Room Builder with 7 players - 2x Mafia', () {
    final roomBuilder = MafiaGameRoomBuilder(false);
    expect(roomBuilder.isReady(), false);
    final p = List.generate(
      MafiaConst.minParticipantsAllPlayers,
      (index) => _createParticipant(index == 0),
    );
    p.forEach((e) {
      roomBuilder.addParticipant(e);
    });
    expect(roomBuilder.isReady(), true);
    final room = roomBuilder.start();
    expect(room, isNotNull);

    if (room == null) {
      throw Exception("Room is not null");
    }

    while (room.board.gameField.isGameOver == false) {
      final Map<MafiaPlayerRole, Set<String>> roles = {};
      room.board.players.forEach((e) {
        if (room.board.gameField.alivePlayers.contains(e.userId)) {
          (roles[e.role] ??= Set()).add(e.userId);
        }
      });

      final phase = room.board.gameField.round.phase;

      if (phase == MafiaGamePhase.night) {
        final nextRole = room.board.gameField.round.nextMoveRole;

        final targetUserId = room.board.gameField.alivePlayers
            .firstWhere((userId) => roles[nextRole]?.contains(userId) == false);

        roles[nextRole]?.forEach((userId) {
          final move = MafiaGameMove(userId, targetUserId, nextRole.ability);
          expect(room.board.makeMove(move), true);
        });
        continue;
      }

      if (phase == MafiaGamePhase.night_summary) {
        final anyUserId = room.board.gameField.alivePlayers.first;
        final move = MafiaGameMove.any(anyUserId);
        expect(room.board.makeMove(move), true);
        continue;
      }

      if (phase == MafiaGamePhase.day) {
        roles.values.forEach((quorum) {
          final target = room.board.gameField.round.playersToEliminate
              .firstWhere((e) => quorum.contains(e) == false);
          quorum.forEach((user) {
            final move = MafiaGameMove.vote(user, target);
            expect(room.board.makeMove(move), true);
          });
        });
        continue;
      }

      if (phase == MafiaGamePhase.day_summary) {
        final anyUser = room.board.gameField.alivePlayers.first;
        final move = MafiaGameMove.any(anyUser);
        expect(room.board.makeMove(move), true);
        continue;
      }
    }

    expect(room.board.gameField.isGameOver, true);
  });
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
