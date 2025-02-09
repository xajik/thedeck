/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'dart:math';

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

void main() {
  test('Test Mafia initialization', () {
    final players = List<MafiaGamePlayer>.generate(
      MafiaPlayerRole.values.length,
      (i) => MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.values[i]),
    );
    final field = MafiaGameField.newField(players);
    final board = MafiaGameBoard(field, players);
    expect(board.gameField.isGameOver, false);
  });

  test('Test Mafia Quorum', () {
    final Map<MafiaPlayerRole, Set<MafiaGamePlayer>> playersRoles = {};

    final players = <MafiaGamePlayer>[];
    for (var i = 0; i < 2; i++) {
      players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia));
    }
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.doctor));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.detective));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.lawyer));
    for (var i = 0; i < 2; i++) {
      players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen));
    }
    players.forEach((e) {
      (playersRoles[e.role] ??= Set()).add(e);
    });

    final gamePlayers = playersRoles.values.fold<int>(
        0, (int previousValue, element) => previousValue + element.length);

    expect(gamePlayers, players.length);

    final field = MafiaGameField.newField(players);
    final board = MafiaGameBoard(field, players);
    expect(board.gameField.isGameOver, false);

    expect(board.gameField.roundPhase, MafiaGamePhase.night);
    expect(board.gameField.round.isRoundOver, false);

    while (board.gameField.roundPhase == MafiaGamePhase.night) {
      final next = board.gameField.round.nextMoveRole;
      final quorum = playersRoles[next] ?? {};
      final target =
          players.firstWhere((e) => !quorum.any((q) => q.userId == e.userId));
      quorum.forEach((e) {
        final move = MafiaGameMove(
          e.userId,
          target.userId,
          e.role.ability,
        );
        expect(board.gameField.round.move(move), true);
      });
    }

    expect(board.gameField.roundPhase, MafiaGamePhase.night_summary);

    final any = players[Random().nextInt(players.length)];
    final move = MafiaGameMove.any(any.userId);
    expect(board.gameField.round.move(move), true);

    expect(board.gameField.roundPhase, MafiaGamePhase.day);

    while (board.gameField.roundPhase == MafiaGamePhase.day) {
      final targetUserId = players[Random().nextInt(players.length)].userId;
      players.forEach((e) {
        if (board.gameField.round.isInGame(e.userId)) {
          var currentUserTarget = targetUserId;
          while (currentUserTarget == e.userId &&
              board.gameField.round.canVoteFor(currentUserTarget)) {
            currentUserTarget =
                players[Random().nextInt(players.length)].userId;
          }
          final move = MafiaGameMove.vote(e.userId, currentUserTarget);
          expect(board.gameField.round.move(move), true);
        }
      });
    }

    expect(board.gameField.roundPhase, MafiaGamePhase.day_summary);
    expect(board.gameField.eliminatedInRound, isNotNull);

    expect(board.gameField.round.move(MafiaGameMove.any(any.userId)), false);

    expect(board.gameField.round.isRoundOver, true);
    expect(board.gameField.isGameOver, false);
  });

  test('Test Mafia Kill & Doctor Heal citizen', () {
    final Map<MafiaPlayerRole, Set<MafiaGamePlayer>> playersRoles = {};

    final players = <MafiaGamePlayer>[];

    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.doctor));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen));

    players.forEach((e) {
      (playersRoles[e.role] ??= Set()).add(e);
    });

    final mafia = playersRoles[MafiaPlayerRole.mafia]!.first;
    final doctor = playersRoles[MafiaPlayerRole.doctor]!.first;
    final citizen = playersRoles[MafiaPlayerRole.citizen]!.first;

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.doctor) {
        final move =
            MafiaGameMove(doctor.userId, citizen.userId, doctor.role.ability);
        expect(round.move(move), true);
      }
      if (nextRole == MafiaPlayerRole.mafia) {
        final move =
            MafiaGameMove(mafia.userId, citizen.userId, mafia.role.ability);
        expect(round.move(move), true);
      }
    }

    expect(round.isInGame(citizen.userId), true);
  });

  test('Test Mafia Kill & Doctor Heal mafiaOne', () {
    final Map<MafiaPlayerRole, Set<MafiaGamePlayer>> playersRoles = {};

    final players = <MafiaGamePlayer>[];

    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.doctor));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen));

    players.forEach((e) {
      (playersRoles[e.role] ??= Set()).add(e);
    });

    final mafia = playersRoles[MafiaPlayerRole.mafia]!.first;
    final doctor = playersRoles[MafiaPlayerRole.doctor]!.first;
    final citizen = playersRoles[MafiaPlayerRole.citizen]!.first;

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.doctor) {
        final move =
            MafiaGameMove(doctor.userId, mafia.userId, doctor.role.ability);
        expect(round.move(move), true);
      }
      if (nextRole == MafiaPlayerRole.mafia) {
        final move =
            MafiaGameMove(mafia.userId, citizen.userId, mafia.role.ability);
        expect(round.move(move), true);
      }
    }

    expect(round.isInGame(citizen.userId), false);
  });

  test('Test Layer immunity', () {
    final Map<MafiaPlayerRole, Set<MafiaGamePlayer>> playersRoles = {};

    final players = <MafiaGamePlayer>[];

    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen));
    players.add(MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.lawyer));

    players.forEach((e) {
      (playersRoles[e.role] ??= Set()).add(e);
    });

    final mafia = playersRoles[MafiaPlayerRole.mafia]!.first;
    final citizen = playersRoles[MafiaPlayerRole.citizen]!.first;
    final lawyer = playersRoles[MafiaPlayerRole.lawyer]!.first;

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.mafia) {
        final move =
            MafiaGameMove(mafia.userId, citizen.userId, mafia.role.ability);
        expect(round.move(move), true);
      }
      if (nextRole == MafiaPlayerRole.lawyer) {
        final move =
            MafiaGameMove(lawyer.userId, lawyer.userId, mafia.role.ability);
        expect(round.move(move), true);
      }
    }

    expect(round.isInGame(citizen.userId), false);

    expect(round.phase, MafiaGamePhase.night_summary);

    final move = MafiaGameMove.any(mafia.userId);
    expect(round.move(move), true);

    expect(round.phase, MafiaGamePhase.day);

    expect(round.move(MafiaGameMove.vote(mafia.userId, lawyer.userId)), false);
    expect(round.move(MafiaGameMove.vote(mafia.userId, citizen.userId)), false);
    expect(
        round.move(MafiaGameMove.vote(lawyer.userId, citizen.userId)), false);
    expect(round.move(MafiaGameMove.vote(lawyer.userId, mafia.userId)), true);
  });

  test('Test Mafia not in Quorum', () {
    final players = <MafiaGamePlayer>[];
    final mafiaOne = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final mafiaTwo = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final citizenOne =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);
    final citizenTwo =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);
    players.add(mafiaOne);
    players.add(mafiaTwo);
    players.add(citizenOne);
    players.add(citizenTwo);
    final round = MafiaGameRound.newRound(0, players);
    expect(round.phase, MafiaGamePhase.night);

    expect(
      round.move(MafiaGameMove.vote(mafiaOne.userId, citizenOne.userId)),
      true,
    );
    expect(
      round.move(MafiaGameMove.vote(mafiaTwo.userId, citizenTwo.userId)),
      true,
    );

    expect(round.phase, MafiaGamePhase.night);

    expect(
      round.move(MafiaGameMove.vote(mafiaTwo.userId, citizenOne.userId)),
      true,
    );

    expect(round.phase, MafiaGamePhase.night_summary);
  });

  test('Test All Mafia Jailed - game over', () {
    final players = <MafiaGamePlayer>[];

    final mafia = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final detective =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.detective);
    final citizen = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);

    players.add(mafia);
    players.add(citizen);
    players.add(detective);

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.mafia) {
        final move =
            MafiaGameMove(mafia.userId, citizen.userId, mafia.role.ability);
        expect(round.move(move), true);
      }
      if (nextRole == MafiaPlayerRole.detective) {
        final move = MafiaGameMove(
            detective.userId, mafia.userId, detective.role.ability);
        expect(round.move(move), true);
      }
    }
    expect(round.phase, MafiaGamePhase.night_summary);
    expect(round.isRoundOver, true);
    expect(round.isGameOver, true);
  });

  test('Test One Mafia is alive Jailed - game over', () {
    final players = <MafiaGamePlayer>[];

    final mafiaTwo = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final mafia = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final detective =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.detective);
    final citizen = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);

    players.add(mafiaTwo);
    players.add(mafia);
    players.add(citizen);
    players.add(detective);

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.mafia) {
        expect(
            round.move(MafiaGameMove(
                mafia.userId, citizen.userId, mafia.role.ability)),
            true);
        expect(
            round.move(MafiaGameMove(
                mafiaTwo.userId, citizen.userId, mafiaTwo.role.ability)),
            true);
      }
      if (nextRole == MafiaPlayerRole.detective) {
        final move = MafiaGameMove(
            detective.userId, mafia.userId, detective.role.ability);
        expect(round.move(move), true);
      }
    }
    expect(round.phase, MafiaGamePhase.night_summary);
    expect(round.isRoundOver, false);
    expect(round.isGameOver, false);
  });

  test('Test Mafia Cannot Kill Mafia', () {
    final players = <MafiaGamePlayer>[];

    final mafiaOne = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final mafiaTwo = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final detective =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.detective);
    final citizen = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);

    players.add(mafiaTwo);
    players.add(mafiaOne);
    players.add(citizen);
    players.add(detective);

    final round = MafiaGameRound.newRound(0, players);

    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.mafia) {
        expect(
            round.move(MafiaGameMove(
                mafiaOne.userId, mafiaTwo.userId, mafiaOne.role.ability)),
            false);
        expect(
            round.move(MafiaGameMove(
                mafiaTwo.userId, mafiaOne.userId, mafiaTwo.role.ability)),
            false);
        expect(
            round.move(MafiaGameMove(
                mafiaTwo.userId, mafiaTwo.userId, mafiaTwo.role.ability)),
            false);
        expect(
            round.move(MafiaGameMove(
                mafiaTwo.userId, citizen.userId, mafiaTwo.role.ability)),
            true);
        expect(
            round.move(MafiaGameMove(
                mafiaOne.userId, citizen.userId, mafiaOne.role.ability)),
            true);
      }
      if (nextRole == MafiaPlayerRole.detective) {
        final move = MafiaGameMove(
            detective.userId, mafiaOne.userId, detective.role.ability);
        expect(round.move(move), true);
      }
    }
    expect(round.phase, MafiaGamePhase.night_summary);
    expect(round.isRoundOver, false);
    expect(round.isGameOver, false);
  });

  test('First move Game over ', () {
    final players = <MafiaGamePlayer>[];

    final mafiaOne = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.mafia);
    final detective =
        MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.detective);
    final citizen = MafiaGamePlayer(Ulid().toUuid(), MafiaPlayerRole.citizen);

    players.add(mafiaOne);
    players.add(citizen);
    players.add(detective);

    final round = MafiaGameRound.newRound(0, players);
    while (round.phase == MafiaGamePhase.night) {
      final nextRole = round.nextMoveRole;
      if (nextRole == MafiaPlayerRole.mafia) {
        expect(
            round.move(MafiaGameMove(
                mafiaOne.userId, citizen.userId, mafiaOne.role.ability)),
            true);
      }
      if (nextRole == MafiaPlayerRole.detective) {
        final move = MafiaGameMove(
            detective.userId, mafiaOne.userId, detective.role.ability);
        expect(round.move(move), true);
      }
    }
    expect(round.isRoundOver, true);
    expect(round.isGameOver, true);
  });
}
