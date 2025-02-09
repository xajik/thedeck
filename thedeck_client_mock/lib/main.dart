import 'dart:io';
import 'dart:math';

import 'package:synchronized/synchronized.dart';
import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

import 'logger.dart';

final Map<String, GameSocketClient> players = {};
final Map<String, GameRoom<MafiaGameBoard>?> rooms = {};
final Set<GameParticipant> connectedParticipants = Set();
bool isGameOver = false;
bool isRoomReady = false;
MafiaGamePlayer? winner = null;
final Lock _lock = Lock();

mixin _Constants {
  static const tag = 'Mock';
}

void main(List<String> arguments) async {
  final logger = Logger();

  final roomIp = arguments[0];
  final roomId = arguments[1];
  final gameIdArg = int.parse(arguments[2]);
  final countArgs = int.parse(arguments[3]);

  logger.d('Create Client: $roomId; $roomIp; $gameIdArg; countArgs',
      tag: _Constants.tag);
  final details = RoomCreateDetails(
    roomIp,
    roomId,
    GamesList.mafia.details,
  );

  for (var i = 0; i < countArgs; i++) {
    final client = GameSocketClient.create(logger);
    final participant = createParticipant(i);
    logger.d(
        'Connecting client: $i : ${participant.userId} with ${client.hashCode}',
        tag: _Constants.tag);
    players[participant.userId] = client;

    final roomListener = MockRoomClientHandler(participant.userId, logger);
    client.roomListener(roomListener, roomId);
    final gameListener = MockMafiaClientHandler(participant.userId, logger);
    client.gameListener(details.details.gameId, gameListener);

    final connected = await client.socketClientUseCase.connect(roomIp, true);

    if (connected == false) {
      print('Failed to connect');
      throw Exception('Failed to connect ${participant.userId}');
    }
    print('User ${participant.userId} joining room $roomId');
    client.joinRoom(roomId, participant);

    Future.delayed(Duration(seconds: 1));
  }

  if (connectedParticipants.length != countArgs) {
    throw Exception(
        'Failed to connect all participants. Connected: ${connectedParticipants.length}; Expected: $countArgs');
  }

  _readCommand();

  do {
    players.forEach((userId, client) async {
      final room = rooms[userId];
      final board = room?.board;
      final players = board?.players;
      final player = board?.players.firstWhere((e) => e.userId == userId);
      final field = board?.gameField;
      final target = board?.players.firstWhere((e) => e.userId != userId);
      final move = MafiaGameMove(userId, target!.userId, player!.role.ability);
      client.clientApi.gameMove(roomId, move);
      await Future.delayed(Duration(seconds: 1));
      logger.d('Move: ${move.toJson()}', tag: _Constants.tag);
      Future.delayed(Duration(seconds: 1));
    });

    if (isGameOver) {
      break;
    }
    _readCommand();
  } while (true);

  logger.d('Game over: $isGameOver; $winner', tag: _Constants.tag);
}

GameParticipant createParticipant(int id) {
  return GameParticipant(
    userId: "user_$id",
    sessionId: Ulid().toUuid(),
    isHost: false,
    profile: ParticipantProfile(
      nickname: "user_$id",
      image: null, //todo add icon support
      score: Random().nextInt(100),
    ),
  );
}

_readCommand() {
  print('Press button to continue');
  stdin.readLineSync();
}

class MockRoomClientHandler extends RoomClientHandler {
  final String userId;
  final Logger logger;

  MockRoomClientHandler(this.userId, this.logger);

  @override
  void observer(GameParticipant observer) {}

  @override
  void participants(List<GameParticipant> p) {
    _lock.synchronized(() {
      logger.d('Participants: ${p.length}', tag: _Constants.tag);
      connectedParticipants.clear();
      connectedParticipants.addAll(p);
    });
  }

  @override
  void roomClosed(String? roomId) {
    logger.d('Room closed: $roomId', tag: _Constants.tag);
  }

  @override
  void roomReady(String roomId, bool isReady) {
    _lock.synchronized(() {
      logger.d('Room ready: $roomId; $isReady', tag: _Constants.tag);
      isRoomReady = isReady;
    });
  }
}

class MockMafiaClientHandler extends MafiaClientHandler {
  final String userId;
  final Logger logger;

  MockMafiaClientHandler(this.userId, this.logger);

  @override
  void gameOver(MafiaGameBoard board, MafiaGamePlayer? w) {
    _lock.synchronized(() {
      final r = rooms[userId]?.copyWith(board: board);
      rooms[userId] = r;
      isGameOver = true;
      winner = w;
    });
  }

  @override
  void newRoom(GameRoom<MafiaGameBoard> room) {
    _lock.synchronized(() {
      rooms[userId] = room;
    });
  }

  @override
  void updateField(MafiaGameField field) {
    _lock.synchronized(() {
      final b = rooms[userId]?.board.copyWith(gameField: field);
      final r = rooms[userId]?.copyWith(board: b);
      rooms[userId] = r;
    });
  }

  @override
  void updateRoom(GameRoom<MafiaGameBoard> room) {
    _lock.synchronized(() {
      rooms[userId] = room;
    });
  }
}
