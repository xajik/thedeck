/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';

import '../../game/room_handler_interface.dart';

List<StreamSubscription> roomClientMessageHandlers(
  SocketMessageStream stream,
  roomId,
  RoomClientHandler dispatcher,
) {
  final subs = <StreamSubscription>[];
  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.participants(roomId),
        ((Map<String, dynamic> map) {
      Iterable<dynamic> i = map[ApiConstantsSocketPayload.data]
          [ApiConstantsSocketPayload.participants];
      List<GameParticipant> participants =
          i.map((e) => GameParticipant.fromJson(e)).toList();
      dispatcher.participants(participants);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.roomClosed(roomId),
        ((Map<String, dynamic> map) {
      final data =
          RoomClosedSocketMessage.fromMap(map[ApiConstantsSocketPayload.data]);
      dispatcher.roomClosed(data.roomId);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.isReady(roomId),
        ((Map<String, dynamic> map) {
      final data =
          SocketRoomIsReadyMessage.fromMap(map[ApiConstantsSocketPayload.data]);
      dispatcher.roomReady(data.roomId, data.isReady);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.observers(roomId),
        ((Map<String, dynamic> map) {
      final data = SocketNewObserverMessage.fromJson(
          map[ApiConstantsSocketPayload.data]);
      dispatcher.observer(data.observer);
    })),
  );
  return subs;
}
