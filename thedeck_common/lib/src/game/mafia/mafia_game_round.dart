/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

import 'dart:collection';

import 'package:thedeck_common/src/game/mafia/mafia_game_roles.dart';
import 'package:thedeck_common/the_deck_common.dart';

class MafiaGameRound {
  final int id;

  MafiaGamePhase _phase = MafiaGamePhase.night;

  MafiaGamePhase get phase => _phase;

  //All alive players when round starts
  final Set<String> _players;

  Set<String> get alivePlayers => _players;

  //Roles that can move during night
  final Queue<MafiaPlayerRole> _nightRoles;

  MafiaPlayerRole get nextMoveRole => _nightRoles.first;

  //You need quorum in case you have multiple mafia
  final Map<MafiaPlayerRole, Set<String>> _nightQuorum;

  //Ability used by player - key - on set of users - value
  final Map<MafiaPlayerAbility, Set<String>> _nightMoves = {};

  Map<MafiaPlayerAbility, Set<String>> get nightMoves => _nightMoves;

  //Target of ability used by player - key - on target player - value
  final Map<String, String> _nightTarget = {};

  //Set of players that can be eliminated during day: alive & without immunity
  final Set<String> _playersToEliminate = Set();

  Set<String> get playersToEliminate => _playersToEliminate;

  //Votes during day - key is the target, value is the set of players that voted
  final Map<String, Set<String>> _dayVotes = {};

  Map<String, Set<String>> get dayVotes => _dayVotes;

  //Results of the round - eliminated players
  String? _dayEliminated;

  //Game over in middle of the round
  bool _isGameOver = false;

  bool get isGameOver => _isGameOver;

  //The round is over
  bool _isRoundOver = false;

  bool get isRoundOver => _isRoundOver;

  //Players eliminated in the round
  String? get eliminatedPlayer => _dayEliminated;

  Set<String> get jailedPlayers => _nightMoves[MafiaPlayerAbility.jail] ?? {};

  MafiaGameRound._(this.id, this._players, this._nightRoles, this._nightQuorum);

  factory MafiaGameRound.newRound(int id, List<MafiaGamePlayer> players) {
    final nightRoles = Queue<MafiaPlayerRole>.from(players
        .map((e) => e.role)
        .where((e) => e.priority > 0)
        .toSet()
        .toList(growable: false));
    final Map<MafiaPlayerRole, Set<String>> nightQuorum = {};
    players.forEach((e) {
      if (e.role.priority > 0) {
        (nightQuorum[e.role] ??= Set()).add(e.userId);
      }
    });
    final playersIds = players.map((e) => e.userId).toSet();
    return MafiaGameRound._(
      id,
      playersIds,
      nightRoles,
      nightQuorum,
    );
  }

  bool move(MafiaGameMove move) {
    if (isRoundOver) {
      return false;
    }
    if (_phase == MafiaGamePhase.night) {
      return _moveNight(move);
    } else if (_phase == MafiaGamePhase.night_summary) {
      _phase = MafiaGamePhase.day;
      return true;
    } else if (_phase == MafiaGamePhase.day) {
      return _moveDay(move);
    } else if (_phase == MafiaGamePhase.day_summary) {
      if (_dayEliminated == null) {
        _dayVotes.clear();
        _phase = MafiaGamePhase.day;
        return true;
      }
    }
    return false;
  }

  bool _moveNight(MafiaGameMove move) {
    final first = _nightRoles.first;
    if (_nightQuorum[first]?.contains(move.userId) == false) {
      return false;
    }

    if (move.ability == MafiaPlayerAbility.kill &&
        _nightQuorum[MafiaPlayerRole.mafia]?.contains(move.targetUserId) ==
            true) {
      return false;
    }

    _nightTarget[move.userId] = move.targetUserId;

    bool haveQuorum = true;
    _nightQuorum[first]?.forEach((e) {
      if (_nightTarget[e] != move.targetUserId) {
        haveQuorum = false;
      }
    });

    if (haveQuorum) {
      (_nightMoves[first.ability] ??= Set()).add(move.targetUserId);
      _nightRoles.removeFirst();
    }

    if (_nightRoles.isEmpty) {
      _players.removeWhere((e) => isInGame(e) == false);
      _players.forEach((e) {
        //Player is alive and not immune
        if (_nightMoves[MafiaPlayerAbility.immunity]?.contains(e) == false) {
          _playersToEliminate.add(e);
        }
      });
      _phase = MafiaGamePhase.night_summary;
      final mafiaInJail = _nightQuorum[MafiaPlayerRole.mafia]?.every((mafia) =>
          _nightMoves[MafiaPlayerAbility.jail]?.contains(mafia) == true);
      if (mafiaInJail == true) {
        _isRoundOver = true;
        _isGameOver = true;
      }
    }
    return true;
  }

  bool _moveDay(MafiaGameMove move) {
    if (isInGame(move.userId) == false) {
      return false;
    }
    if (_playersToEliminate.contains(move.targetUserId) == false) {
      return false;
    }
    _dayVotes.values.forEach((e) => e.remove(move.userId));
    (_dayVotes[move.targetUserId] ??= Set()).add(move.userId);

    if (_dayVotes.values
            .reduce((value, element) => value..addAll(element))
            .length ==
        _players.length) {
      _dayEliminated = isEliminated();
      if (_dayEliminated != null) {
        _isRoundOver = true;
      }
      _phase = MafiaGamePhase.day_summary;
    }
    return true;
  }

  bool allVoted() {
    final count = _players.length;
    return _dayVotes.values
            .reduce((value, element) => value..addAll(element))
            .toSet()
            .length ==
        count;
  }

  bool canVoteFor(String userId) =>
      isInGame(userId) && _playersToEliminate.contains(userId) == false;

  bool isInGame(String userId) =>
      !(_nightMoves[MafiaPlayerAbility.kill]?.contains(userId) ?? false) ||
      (_nightMoves[MafiaPlayerAbility.heal]?.contains(userId) ?? false);

  String? isEliminated() {
    if (_dayVotes.isEmpty) {
      return null;
    }

    final majority = _dayVotes
        .map((key, value) => MapEntry(key, value.length))
        .entries
        .reduce(
            (value, element) => value.value > element.value ? value : element);

    if (majority.value > _players.length / 2) {
      return majority.key;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phase': _phase.name,
      'players': _players.toList(),
      'nightRoles': _nightRoles.map((e) => e.name).toList(),
      'nightQuorum':
          _nightQuorum.map((key, value) => MapEntry(key.name, value.toList())),
      'nightMoves': _nightMoves.map((key, value) => MapEntry(key, value.toList())),
      'nightTarget': _nightTarget,
      'playersToEliminate': _playersToEliminate.toList(),
      'dayVotes': _dayVotes.map((key, value) => MapEntry(key, value.toList())),
      'dayEliminated': _dayEliminated,
    };
  }

  factory MafiaGameRound.fromMap(Map<String, dynamic> map) {
    return MafiaGameRound._(
        map['id'],
        Set<String>.from(map['players']),
        Queue<MafiaPlayerRole>.from(
            map['nightRoles'].map((e) => MafiaPlayerRole.fromName(e))),
        map['nightQuorum'].map<MafiaPlayerRole, Set<String>>((key, value) =>
            MapEntry(MafiaPlayerRole.fromName(key), Set<String>.from(value))))
      .._phase = MafiaGamePhase.fromName(map['phase'])
      .._nightMoves.addAll(
        Map<MafiaPlayerAbility, Set<String>>.from(map['nightMoves']),
      )
      .._nightTarget.addAll(
        Map<String, String>.from(map['nightTarget']),
      )
      .._playersToEliminate.addAll(
        Set<String>.from(map['playersToEliminate']),
      )
      .._dayVotes.addAll(
        Map<String, Set<String>>.from(map['dayVotes']),
      )
      .._dayEliminated = map['dayEliminated'];
  }
}
