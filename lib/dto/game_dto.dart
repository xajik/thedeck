/*
 *
 *  *
 *  * Created on 22 4 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class Game {
  final GamesList game;
  final String? id;

  get image => game.image;

  get details => game.details;

  title(locale) => game.title(locale);

  Game(this.game, {this.id});

  factory Game.fromGamesList(GamesList e, {String? id}) {
    return Game(
      e,
      id: id,
    );
  }
}
