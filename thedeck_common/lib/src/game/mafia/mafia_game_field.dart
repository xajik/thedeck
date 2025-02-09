/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

import 'dart:collection';
import '../../../the_deck_common.dart';

class MafiaGameField extends GameField {
  final Queue<MafiaGameRound> _rounds = Queue();
  final List<MafiaGamePlayer> _players;
  final Set<String> _eliminatedPlayers = Set();

  MafiaGameRound get round => _rounds.first;

  MafiaGamePhase get roundPhase => round.phase;

  Set<String> get alivePlayers => round.alivePlayers;

  Map<MafiaPlayerAbility, Set<String>> get nightMoves => round.nightMoves;

  String? get eliminatedInRound => round.eliminatedPlayer;

  MafiaGameField._(this._players);

  factory MafiaGameField.newField(List<MafiaGamePlayer> players) {
    final round = MafiaGameRound.newRound(0, players);
    var field = MafiaGameField._(players).._rounds.add(round);
    return field;
  }

  bool move(MafiaGameMove move) {
    if (round.isRoundOver) {
      final eliminatedPlayer = round.eliminatedPlayer;
      if (eliminatedPlayer != null) {
        _moveToNewRound(eliminatedPlayer);
        return true;
      }
      return false;
    }
    return round.move(move);
  }

  void _moveToNewRound(String eliminatedPlayer) {
    _players.removeWhere((e) => e.userId == eliminatedPlayer);
    final round = MafiaGameRound.newRound(_rounds.length + 1, _players);
    _rounds.addFirst(round);
  }

  @override
  bool get isGameOver {
    return (_rounds.isNotEmpty && _rounds.first.isGameOver) ||
        !_players.any((e) => e.role == MafiaPlayerRole.mafia) ||
        _players.where((e) => e.role == MafiaPlayerRole.mafia).length >
            _players.where((e) => e.role != MafiaPlayerRole.mafia).length ||
        _players.length <= 1;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "players": _players.map((p) => p.toMap()).toList(),
      'rounds': _rounds.map((r) => r.toMap()).toList(),
      'eliminatedPlayers': _eliminatedPlayers.toList()
    };
  }

  factory MafiaGameField.fromMap(Map<String, dynamic> map) {
    final players = List<MafiaGamePlayer>.from(
      map['players'].map((p) => MafiaGamePlayer.fromMap(p)),
    );

    return MafiaGameField._(players)
      .._rounds.addAll(
        List<MafiaGameRound>.from(
          map['rounds'].map((r) => MafiaGameRound.fromMap(r)),
        ),
      )
      .._eliminatedPlayers.addAll(
        List<String>.from(map['eliminatedPlayers']),
      );
  }
}
