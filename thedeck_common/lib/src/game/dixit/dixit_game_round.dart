/*
 *
 *  *
 *  * Created on 4 4 2023
 *
 */


import '../../encodable/encodable_json.dart';
import 'dixit_game_deck.dart';

enum DixitGameRoundState {
  storytellerChoosingCard,
  playersChoosingCard,
  playersVote,
  roundEnded,
}

class DixitGameRound extends JsonEncodeable {
  final int playersCount;
  var _gameState = DixitGameRoundState.storytellerChoosingCard;
  final String _storyTellerUserId;

  StoryTellerCard? _storyTellerCard;
  final Map<String, List<DixitGameCard>> _playerSelectedCards = {};
  final Map<String, List<DixitGameCard>> _playersVote = {};

  get gameState => _gameState;

  String get storytellerUserId => _storyTellerUserId;

  StoryTellerCard? get storyTellerCard => _storyTellerCard;

  Map<String, List<DixitGameCard>> get playersVote => _playersVote;

  Map<String, List<DixitGameCard>> get playerSelectedCards =>
      _playerSelectedCards;

  List<DixitGameCard> _cardsForVote = List.empty(growable: true);

  List<DixitGameCard> get cardsForVote => _cardsForVote;

  DixitGameRound(this.playersCount, this._storyTellerUserId);

  bool setStoryTellerCard(StoryTellerCard card) {
    if (DixitGameRoundState.storytellerChoosingCard != _gameState ||
        _storyTellerUserId != card.userId) {
      return false;
    }
    _storyTellerCard = card;
    _gameState = DixitGameRoundState.playersChoosingCard;
    return true;
  }

  bool addPlayerSelectedCards(String userId, List<DixitGameCard> cards) {
    if (DixitGameRoundState.playersChoosingCard != _gameState ||
        cards.isEmpty ||
        _playerSelectedCards[userId]?.isNotEmpty == true) {
      return false;
    }
    _playerSelectedCards[userId] = cards;
    if (_playerSelectedCards.length == playersCount) {
      _gameState = DixitGameRoundState.playersVote;
      _cardsForVote = [
        _storyTellerCard!.card,
        ...playerSelectedCards.entries.expand((entry) => entry.value).toList(),
      ];
      _cardsForVote.shuffle();
    }
    return true;
  }

  bool addPlayerVotesCards(String userId, List<DixitGameCard> cards) {
    if (DixitGameRoundState.playersVote != _gameState ||
        cards.isEmpty ||
        _playersVote[userId]?.isNotEmpty == true) {
      return false;
    }
    if (cards.any((element) =>
        _playerSelectedCards[userId]?.contains(element) ?? false)) {
      return false;
    }
    _playersVote[userId] = cards;
    if (_playersVote.length == playersCount) {
      _gameState = DixitGameRoundState.roundEnded;
    }
    return true;
  }

  factory DixitGameRound.fromMap(Map<String, dynamic> map) {
    final round = DixitGameRound(map['playersCount'], map['storyTellerUserId']);
    round._gameState = DixitGameRoundState.values[map['gameState']];
    final storytellerCardJson = map['storyTellerCard'];
    if (storytellerCardJson != null) {
      round._storyTellerCard = StoryTellerCard.fromMap(storytellerCardJson);
    }
    final Map<String, List<DixitGameCard>> playerSelectedCards =
        (map['playerSelectedCards'] as Map<String, dynamic>?)
                ?.map((key, value) {
              return MapEntry(
                key,
                List<DixitGameCard>.from(
                  value.map((card) => DixitGameCard.fromMap(card)),
                ),
              );
            }) ??
            {};
    final Map<String, List<DixitGameCard>> playersVote =
        (map['playersVote'] as Map<String, dynamic>?)?.map((key, value) {
              return MapEntry(
                key,
                List<DixitGameCard>.from(
                  value.map((card) => DixitGameCard.fromMap(card)),
                ),
              );
            }) ??
            {};

    List<DixitGameCard> cardsForVote =
        (map['cardsForVote'] as List<dynamic>).map((card) {
      return DixitGameCard.fromMap(card);
    }).toList();

    round._playerSelectedCards.addAll(playerSelectedCards);
    round._playersVote.addAll(playersVote);
    round._cardsForVote.addAll(cardsForVote);
    return round;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = {
      'playersCount': playersCount,
      'gameState': _gameState.index,
      'storyTellerUserId': _storyTellerUserId,
      'cardsForVote': _cardsForVote.map((e) => e.toMap()).toList(),
      'playerSelectedCards': _playerSelectedCards.map(
        (key, value) => MapEntry(
          key,
          value.map((e) => e.toMap()).toList(),
        ),
      ),
      'playersVote': _playersVote.map((key, value) => MapEntry(
            key,
            value.map((e) => e.toMap()).toList(),
          )),
    };

    var storyTellerCard = _storyTellerCard;
    if (storyTellerCard != null) {
      map['storyTellerCard'] = storyTellerCard.toMap();
    }
    return map;
  }
}

class StoryTellerCard extends JsonEncodeable {
  final String userId;
  final DixitGameCard card;
  final String? story;

  StoryTellerCard(this.userId, this.card, this.story);

  factory StoryTellerCard.fromMap(Map<String, dynamic> json) {
    return StoryTellerCard(
      json['userId'],
      DixitGameCard.fromMap(json),
      json['story'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'story': story,
      ...card.toMap(),
    };
  }
}
