/*
 *
 *  *
 *  * Created on 31 1 2023
 *
 */

import 'game_details.dart';

enum GamesList {
  ticTacToe,
  connectFour,
  dixit,
  mafia,
}

extension GamesListExtension on GamesList {

  static bool existsByDetails(GameDetails details) {
    return GamesList.values
        .any((element) => element.details.gameId == details.gameId);
  }

  static GamesList? getById(int gameId) {
    var i = GamesList.values.indexWhere((e) => e.details.gameId == gameId);
    if (i < 0) {
      return null;
    }
    return GamesList.values[i];
  }

  int get complexity {
    switch (this) {
      case GamesList.ticTacToe:
        return 1;
      case GamesList.connectFour:
        return 2;
      case GamesList.dixit:
        return 3;
      case GamesList.mafia:
        return 5;
      default:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case GamesList.ticTacToe:
        return 'Tic-Tac-Toe';
      case GamesList.connectFour:
        return 'ConnectFour';
      case GamesList.dixit:
        return 'Dixit';
      case GamesList.mafia:
        return 'Mafia';
      default:
        return "Unknown";
    }
  }

  String title(locale) {
    switch (this) {
      case GamesList.ticTacToe:
        return locale.ticTacToe;
      case GamesList.connectFour:
        return locale.connectFour;
      case GamesList.dixit:
        return locale.dixit;
      case GamesList.mafia:
        return locale.mafia;
      default:
        return locale.loading;
    }
  }

  int get id {
    switch (this) {
      case GamesList.ticTacToe:
        return 1;
      case GamesList.connectFour:
        return 2;
      case GamesList.dixit:
        return 3;
      case GamesList.mafia:
        return 4;
      default:
        return -1;
    }
  }

  GameDetails get details => GameDetails(gameId: id, gameName: name);

  String get image {
    switch (this) {
      case GamesList.ticTacToe:
        return _Constants.ticTacToe;
      case GamesList.connectFour:
        return _Constants.connectFour;
      case GamesList.dixit:
        return _Constants.dixit;
      case GamesList.mafia:
        return _Constants.placeholder; //TODO: update
      default:
        return _Constants.placeholder;
    }
  }
}

mixin _Constants {
  static const dixit = "assets/image/game/dixit.png";
  static const connectFour = "assets/image/game/connect_four.png";
  static const ticTacToe = "assets/image/game/tic_tac_toe.png";
  static const placeholder = "assets/image/game/placeholder.png";
}
