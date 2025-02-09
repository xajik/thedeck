/*
 *
 *  *
 *  * Created on 12 2 2023
 *
 */


import '../encodable/encodable_json.dart';

class GameDetails extends JsonEncodeable {
  final int gameId;
  final String gameName;

  GameDetails({required this.gameId, required this.gameName});

  @override
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'gameName': gameName,
    };
  }

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      gameId: json['gameId'],
      gameName: json["gameName"],
    );
  }
}