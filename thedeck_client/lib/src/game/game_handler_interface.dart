/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

abstract class GameClientHandler<T extends GameBoard, Y extends GameField,
    Z extends GamePlayer> {
  void newRoom(GameRoom<T> room);

  //Currently used only in the Replay flow
  void updateRoom(GameRoom<T> room);

  void updateField(Y field);

  void gameOver(T board, Z? winner);
}
