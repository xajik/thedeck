/*
 *
 *  *
 *  * Created on 19 5 2023
 *
 */


import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';

void main() {

    test('cardsCount should return the correct number of cards', () {
      final deck = DixitGameCardDeck.create();
      expect(deck.cardsCount, 84);
    });

    test('discardCount should return the correct number of discarded cards',
        () {
      final deck = DixitGameCardDeck.create();
      expect(deck.discardCount, 0);
      deck.discardCard(DixitGameCard(1, 'Card 1', 'image1.jpeg'));
      expect(deck.discardCount, 1);
    });

    test('drawCard should remove and return the top card from the deck', () {
      final deck = DixitGameCardDeck.create();
      final card = deck.drawCard();
      expect(card, isNotNull);
      expect(deck.cardsCount, 83);
    });

    test('drawCards should return a list of the specified number of cards', () {
      final deck = DixitGameCardDeck.create();
      final cards = deck.drawCards(5);
      expect(cards, hasLength(5));
      expect(deck.cardsCount, 79);
    });

    test('toMap should return a map representation of the deck', () {
      final deck = DixitGameCardDeck.create();
      final card1 = deck.drawCard();
      final card2 = deck.drawCard();
      deck.discardCard(card1);
      deck.discardCard(card2);

      final deckMap = deck.toMap();

      expect(deckMap, isA<Map<String, dynamic>>());
      expect(deckMap['discard'], hasLength(2));
      expect(deckMap['discard'], containsAll([card1.toMap(), card2.toMap()]));
      expect(deckMap['cards'], hasLength(82)); // 84 - 2 discarded cards
    });
}
