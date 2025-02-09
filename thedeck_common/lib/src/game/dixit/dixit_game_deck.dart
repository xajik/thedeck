/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

import 'dart:collection';
import 'dart:math';

import '../../encodable/encodable_json.dart';


class DixitGameCardDeck extends JsonEncodeable {
  final Queue<DixitGameCard> _deck;
  final Queue<DixitGameCard> _discard;

  DixitGameCardDeck._(List<DixitGameCard> cards)
      : _deck = Queue.from(cards),
        _discard = Queue();

  DixitGameCardDeck._fromMap(this._deck, this._discard);

  int get cardsCount => _deck.length;

  int get discardCount => _discard.length;

  DixitGameCard drawCard() {
    if (_deck.isEmpty) {
      final list = _discard.toList();
      list.shuffle();
      _deck.addAll(list);
      _discard.clear();
    }
    return _deck.removeFirst();
  }

  void discardCard(DixitGameCard card) {
    _discard.add(card);
  }

  factory DixitGameCardDeck.create([int count = _Constants.deckCardCount]) {
    final rand = Random();
    final offset = rand.nextInt(_Constants.serverCardCount);
    var list = List.generate(count, (number) {
      var index = offset + number;
      if (index > _Constants.serverCardCount) {
        index = index - _Constants.serverCardCount;
      }
      return DixitGameCard(
        index,
        "Card $index",
        _Constants.imageUrl(index),
      );
    });
    list.shuffle();
    return DixitGameCardDeck._(list);
  }

  List<DixitGameCard> drawCards(int i) {
    return List.generate(i, (index) => drawCard());
  }

  factory DixitGameCardDeck.fromMap(Map<String, dynamic> map) {
    List<dynamic> discardList = map['discard'];
    Queue<DixitGameCard> discard = Queue.from(
        discardList.map((cardMap) => DixitGameCard.fromMap(cardMap)));
    List<dynamic> cardsList = map['cards'];
    Queue<DixitGameCard> cards =
        Queue.from(cardsList.map((cardMap) => DixitGameCard.fromMap(cardMap)));
    return DixitGameCardDeck._fromMap(cards, discard);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'discard': _discard.map((e) => e.toMap()).toList(),
      'cards': _deck.map((e) => e.toMap()).toList(),
    };
  }
}

class _Constants {
  static const int deckCardCount = 84;
  static const int serverCardCount = 90;

  static imageUrl(id) => "https://getthedeck.com/assets/dixit/$id.jpeg";
}

class DixitGameCard extends JsonEncodeable {
  final int _cardId;
  final String _cardText;
  final String _cardImageUrl;

  DixitGameCard(this._cardId, this._cardText, this._cardImageUrl);

  get cardId => _cardId;

  get cardText => _cardText;

  get cardImage => _cardImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'cardId': _cardId,
      'cardText': _cardText,
      'cardImageUrl': _cardImageUrl,
    };
  }

  factory DixitGameCard.fromMap(Map<String, dynamic> map) {
    return DixitGameCard(
      map['cardId'],
      map['cardText'],
      map['cardImageUrl'],
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DixitGameCard && other.cardId == cardId;

  @override
  int get hashCode => cardId;
}
