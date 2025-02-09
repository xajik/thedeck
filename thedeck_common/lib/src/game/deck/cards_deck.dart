/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

enum Suit {
  spades,
  hearts,
  diamonds,
  clubs,
}

class Card {
  final Suit suit;
  final int rank;

  const Card({required this.suit, required this.rank});

  @override
  String toString() {
    var rankStr = rank.toString();
    switch (rank) {
      case 11:
        rankStr = 'J';
        break;
      case 12:
        rankStr = 'Q';
        break;
      case 13:
        rankStr = 'K';
        break;
      case 14:
        rankStr = 'A';
        break;
    }
    switch (suit) {
      case Suit.spades:
        return '$rankStr♠';
      case Suit.hearts:
        return '$rankStr♥';
      case Suit.diamonds:
        return '$rankStr♦';
      case Suit.clubs:
        return '$rankStr♣';
    }
  }

  String path() => _Constants.path(toString());
}

List<Card> getDeck() {
  final deck = <Card>[];
  for (var suit in Suit.values) {
    for (var rank = 2; rank <= 14; rank++) {
      deck.add(Card(suit: suit, rank: rank));
    }
  }
  return deck;
}

mixin _Constants {
  static const extension = ".jpg";
  static path(name) => "$name.$extension";
}
