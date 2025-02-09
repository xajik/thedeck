/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

import 'dart:collection';
import 'dart:math';

import '../game_board.dart';
import 'dixit_game_move.dart';
import 'dixit_game_deck.dart';
import 'dixit_game_player.dart';
import 'dixit_game_round.dart';

class DixitGameField extends GameField {
  final Queue<String> _players;
  final DixitGameCardDeck _deck;
  final Map<String, List<DixitGameCard>> _handCards;
  final Map<String, int> _gameScore = {};
  DixitGameRound _currentRound;

  DixitGameCardDeck get cardDeck => _deck;

  get winner => _gameScore.entries
      .reduce((value, element) => value.value > element.value ? value : element)
      .key;

  Map<String, int> get gameScore => _gameScore;

  DixitGameRound get round => _currentRound;

  get storyteller => _currentRound.storytellerUserId;

  get storytellerCard => _currentRound.storyTellerCard;

  get roundState => _currentRound.gameState;

  get playerSelectedCards => _currentRound.playerSelectedCards;

  get handCards => _handCards;

  DixitGameField._(
      String storytellerUserId, this._players, this._deck, this._handCards)
      : _currentRound = DixitGameRound(_players.length, storytellerUserId);

  DixitGameField._withRound(
      this._currentRound, this._players, this._deck, this._handCards);

  factory DixitGameField.newField(List<DixitGamePlayer> players,
      {DixitGameCardDeck? cardDeck}) {
    players.shuffle();
    final queue = Queue<String>.from(players.map((e) => e.userId));
    final storyteller = queue.removeFirst();
    final deck = cardDeck ?? DixitGameCardDeck.create();
    final handCards = <String, List<DixitGameCard>>{};
    var getCardsCount = _Constants.getCardsCount(players.length);
    for (final player in players) {
      handCards[player.userId] = deck.drawCards(getCardsCount);
    }
    return DixitGameField._(storyteller, queue, deck, handCards);
  }

  bool move(DixitGameMove move) {
    switch (_currentRound.gameState) {
      case DixitGameRoundState.storytellerChoosingCard:
        return _storytellerChoosingCard(move);
      case DixitGameRoundState.playersChoosingCard:
        return _playersChoosingCard(move);
      case DixitGameRoundState.playersVote:
        final vote = _playersVote(move);
        if (_currentRound.gameState == DixitGameRoundState.roundEnded) {
          isGameOver = _countVotes();
        }
        return vote;
      case DixitGameRoundState.roundEnded:
        if (isGameOver) {
          return false;
        }
        if (move.cards.isEmpty) {
          _moveToNewRound();
          return true;
        }
        return false;
    }
    return false;
  }

  void _moveToNewRound() {
    _players.addLast(_currentRound.storytellerUserId);
    var getCardsCount = _Constants.getCardsCount(_players.length);
    for (final player in _players) {
      final card = _handCards[player];
      _currentRound.playerSelectedCards[player]?.forEach((element) {
        card?.remove(element);
        _deck.discardCard(element);
      });
      card?.remove(storytellerCard.card);
      _deck.discardCard(storytellerCard.card);
      while (card!.length < getCardsCount) {
        card.add(_deck.drawCard());
      }
    }
    final storyteller = _players.removeFirst();
    _currentRound = DixitGameRound(_players.length, storyteller);
  }

  bool _countVotes() {
    var scoreMap = _calculateScore(_currentRound);
    scoreMap.forEach((key, value) {
      _gameScore[key] = (_gameScore[key] ?? 0) + value;
    });
    return _gameScore.values.any((element) => element >= _Constants.maxScore);
  }

  Map<String, int> _calculateScore(DixitGameRound round) {
    final storyTeller = round.storytellerUserId;
    final storyTellerCard = round.storyTellerCard!.card;
    final selectedCards = round.playerSelectedCards;
    final votes = round.playersVote;
    final scores = <String, int>{};
    // Calculate the score for the story teller
    final votesForStoryTellerCard = votes.values
        .where((v) => v.contains(storyTellerCard))
        .length; // count the number of votes for the story teller's card
    if (votesForStoryTellerCard == 0 ||
        votesForStoryTellerCard == round.playersCount) {
      // if no one voted for the card, or everyone voted for the card
      // the story teller gets no points
      scores[storyTeller] = 0;
    } else {
      // the story teller gets 2 points for having told a good story
      // add the number of votes for the card to the story teller's score
      scores[storyTeller] = 2 + votesForStoryTellerCard;
    }

    // Calculate the score for the other players
    selectedCards.forEach((player, cards) {
      // skip the story teller's score
      if (player == storyTeller) return;
      int score = 0;
      votes.forEach((voter, vote) {
        // skip the player's own vote
        if (voter == player) return;

        for (var v in vote) {
          if (cards.contains(v)) {
            score++; // count the number of correct votes for the player's card
          }
        }
      });
      scores[player] = score;
    });

    votes.forEach((voter, vote) {
      final score = scores[voter] ?? 0;
      if (voter == storyTeller) {
        return;
      }
      if (vote.contains(storyTellerCard)) {
        scores[voter] = score + 2;
      }
    });

    return scores;
  }

  bool _storytellerChoosingCard(DixitGameMove move) {
    if (move.userId != storyteller) {
      return false;
    }
    return _currentRound.setStoryTellerCard(StoryTellerCard(
      storyteller,
      move.cards.first,
      move.story,
    ));
  }

  bool _playersChoosingCard(DixitGameMove move) {
    if (move.userId == storyteller) {
      return false;
    }
    final userId = _players.firstWhere((element) => element == move.userId);
    return _currentRound.addPlayerSelectedCards(userId, move.cards);
  }

  bool _playersVote(DixitGameMove move) {
    if (move.userId == storyteller) {
      return false;
    }
    final userId = _players.firstWhere((userId) => userId == move.userId);
    return _currentRound.addPlayerVotesCards(userId, move.cards);
  }

  factory DixitGameField.fromMap(Map<String, dynamic> map) {
    final players = Queue<String>.from(map['players']);
    final deck = DixitGameCardDeck.fromMap(map['deck']);

    final Map<String, List<DixitGameCard>> handCards =
        (map['handCards'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(
        key,
        List<DixitGameCard>.from(
          value.map((card) => DixitGameCard.fromMap(card)),
        ),
      );
    });

    final currentRound = DixitGameRound.fromMap(map['currentRound']);
    final Map<String, int> gameScore = map['gameScore'].map<String, int>(
      (String key, dynamic value) => MapEntry(key, value as int),
    );
    final field = DixitGameField._withRound(
      currentRound,
      players,
      deck,
      handCards,
    );
    field.isGameOver = map['isGameOver'];
    field._gameScore.addAll(gameScore);
    return field;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'players': _players.toList(),
      'deck': _deck.toMap(),
      'handCards': _handCards
          .map((key, value) =>
              MapEntry(key, value.map((e) => e.toMap()).toList()))
          .cast<String, List<Map<String, dynamic>>>(),
      'currentRound': _currentRound.toMap(),
      'gameScore': _gameScore
          .map((key, value) => MapEntry(key, value))
          .cast<String, int>(),
    };
  }
}

class _Constants {
  static const int maxScore = 30;

  static int getCardsCount(int playersCount) => playersCount <= 3 ? 6 : 7;
}
