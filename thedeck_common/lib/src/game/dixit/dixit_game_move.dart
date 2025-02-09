/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

import '../game_board.dart';
import 'dixit_game_deck.dart';

class DixitGameMove extends GameMove {
  List<DixitGameCard> cards;
  String? story;

  DixitGameMove(String userId, this.cards, [this.story]) : super(userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'story': story,
      'cards': cards.map((card) => card.toMap()).toList(),
    };
  }

  factory DixitGameMove.fromMap(Map<String, dynamic> map) {
    final userId = map['userId'];
    final story = map['story'];
    var cards = (map['cards'] as List)
        .map((e) => DixitGameCard.fromMap(e))
        .toList(growable: false);
    return DixitGameMove(
      userId,
      cards,
      story,
    );
  }
}
