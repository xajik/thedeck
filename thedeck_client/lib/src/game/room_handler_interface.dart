/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

abstract class RoomClientHandler {
  void participants(List<GameParticipant> participants);

  void roomClosed(String? roomId);

  void roomReady(String roomId, bool isReady);

  void observer(GameParticipant observer);
}
