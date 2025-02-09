/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/src/room/provider/game_room_builder_provider.dart';
import 'package:thedeck_server/src/room/provider/game_room_provider.dart';
import 'package:thedeck_server/src/socket/api/server_socket_api.dart';

List<StreamSubscription> roomServerMessageHandlers(
  SocketMessageStream stream,
  roomId,
  GameRoomBuilderProvider gameRoomBuilderProvider,
  ServerSocketApi serverApi,
  GameRoomProvider gameRoomProvider,
) {
  final subs = <StreamSubscription>[];
  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.join(roomId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final participant = GameParticipant.fromJson(
        map[ApiConstantsSocketPayload.data],
        socketId,
      );
      final builder = gameRoomBuilderProvider.get(roomId);
      if (builder == null) {
        //TODO send error to sender;
        return;
      }
      final add = builder.isParticipant(participant) == false;
      if (add == true) {
        builder.addParticipant(participant);
        final participants =
            SocketListParticipantsMessage(builder.participants);
        serverApi.listParticipant(roomId, participants, true);

        final isReady = SocketRoomIsReadyMessage(roomId, builder.isReady());
        serverApi.isRoomReady(roomId, isReady);
      } else {
        //TODO send error to sender;
      }
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.roomReconnect(roomId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final participant = ParticipantReconnectSocketMessage.fromMap(
          map[ApiConstantsSocketPayload.data]);
      final room = gameRoomProvider.get(roomId);
      if (room == null || room.board.gameField.isGameOver) {
        //TODO send error;
        return;
      }
      final isParticipant =
          room.participants.any((p) => p.userId == participant.userId);
      if (!isParticipant) {
        //TODO send error;
        return;
      }
      final gameId = room.details.gameId;
      final message = GameRoomSocketMessage(gameId, room);
      serverApi.gameRoom(gameId, message, socketId);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.subscribe(roomId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final observer = GameParticipant.fromJson(
        map[ApiConstantsSocketPayload.data],
        socketId,
      );
      final message = SocketNewObserverMessage(observer);
      serverApi.listObservers(roomId, message);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.clientDisconnected(roomId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final user = ClientDisconnectSocketMessage.fromMap(
          map[ApiConstantsSocketPayload.data], socketId);
      final userId = user.userId;
      if (userId != null) {
        final builder = gameRoomBuilderProvider.get(roomId);
        builder?.removeParticipant(userId);
      }
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.onDisconnect(),
        ((Map<String, dynamic> map) {
      final data = SocketDisconnectedSocketMessage.fromMap(map);
      final builder = gameRoomBuilderProvider.get(roomId);
      if (builder != null) {
        builder.participants.forEach((e) {
          if (e.socketId == data.socketId) {
            builder.removeParticipant(e.userId);
          }
        });
        final participants =
            SocketListParticipantsMessage(builder.participants);
        serverApi.listParticipant(roomId, participants, true);

        final isReady = SocketRoomIsReadyMessage(roomId, builder.isReady());
        serverApi.isRoomReady(roomId, isReady);
      }
    })),
  );

  return subs;
}
