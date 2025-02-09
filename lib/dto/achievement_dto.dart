/*
 *
 *  *
 *  * Created on 22 4 2023
 *
 */

import 'package:the_deck/dto/game_statistics.dart';
import 'package:thedeck_common/the_deck_common.dart';

enum Achievement {
  firstRun,
  firstGame,
  firstWin,
  firstWinTicTacToe,
  firstWinConnectFour,
  firstWinDixit,
  first10Games,
  first10Wins,
  first50Games,
  first50Wins,
  first100Games,
  first100Wins,
}

extension AchievementExtension on Achievement {
  String get image {
    switch (this) {
      case Achievement.firstRun:
        return _Constant.firstRun;
      case Achievement.firstGame:
        return _Constant.firstGame;
      case Achievement.firstWin:
        return _Constant.firstWin;
      case Achievement.firstWinTicTacToe:
        return _Constant.firstWinTicTacToe;
      case Achievement.firstWinConnectFour:
        return _Constant.firstWinConnectFour;
      case Achievement.firstWinDixit:
        return _Constant.firstWinDixit;
      case Achievement.first10Games:
        return _Constant.first10Games;
      case Achievement.first10Wins:
        return _Constant.first10Wins;
      case Achievement.first50Games:
        return _Constant.first50Games;
      case Achievement.first50Wins:
        return _Constant.first50Wins;
      case Achievement.first100Games:
        return _Constant.first100Games;
      case Achievement.first100Wins:
        return _Constant.first100Wins;
      default:
        return _Constant.placeholder;
    }
  }

  String title(localisation) {
    switch (this) {
      case Achievement.firstRun:
        return localisation.firstRun;
      case Achievement.firstGame:
        return localisation.firstGame;
      case Achievement.firstWin:
        return localisation.firstWin;
      case Achievement.firstWinTicTacToe:
        return localisation.firstWinTicTacToe;
      case Achievement.firstWinConnectFour:
        return localisation.firstWinConnectFour;
      case Achievement.firstWinDixit:
        return localisation.firstWinDixit;
      case Achievement.first10Games:
        return localisation.first10Games;
      case Achievement.first10Wins:
        return localisation.first10Wins;
      case Achievement.first50Games:
        return localisation.first50Games;
      case Achievement.first50Wins:
        return localisation.first50Wins;
      case Achievement.first100Games:
        return localisation.first100Games;
      case Achievement.first100Wins:
        return localisation.first100Wins;
      default:
        return localisation.loading;
    }
  }

  bool achieved(GameStatistics statistics) {
    switch (this) {
      case Achievement.firstRun:
        return true;
      case Achievement.firstGame:
        return statistics.games.values.isNotEmpty;
      case Achievement.firstWin:
        return statistics.wins.values.isNotEmpty;
      case Achievement.firstWinTicTacToe:
        return (statistics.wins[GamesList.ticTacToe.id] ?? 0) > 0;
      case Achievement.firstWinConnectFour:
        return (statistics.wins[GamesList.connectFour.id] ?? 0) > 0;
      case Achievement.firstWinDixit:
        return (statistics.wins[GamesList.dixit.id] ?? 0) > 0;
      case Achievement.first10Games:
        return statistics.games.values.isNotEmpty &&
            statistics.games.values
                    .reduce((value, element) => value + element) >=
                10;
      case Achievement.first10Wins:
        return statistics.wins.values.isNotEmpty &&
            statistics.wins.values
                    .reduce((value, element) => value + element) >=
                10;
      case Achievement.first50Games:
        return statistics.games.values.isNotEmpty &&
            statistics.games.values
                    .reduce((value, element) => value + element) >=
                50;
      case Achievement.first50Wins:
        return statistics.wins.values.isNotEmpty &&
            statistics.wins.values
                    .reduce((value, element) => value + element) >=
                50;
      case Achievement.first100Games:
        return statistics.games.values.isNotEmpty &&
            statistics.games.values
                    .reduce((value, element) => value + element) >=
                100;
      case Achievement.first100Wins:
        return statistics.wins.values.isNotEmpty &&
            statistics.wins.values
                    .reduce((value, element) => value + element) >=
                100;
      default:
        return false;
    }
  }
}

mixin _Constant {
  static const firstRun = "assets/image/achievement/first_run.png";
  static const firstGame = "assets/image/achievement/first_game.png";
  static const firstWin = "assets/image/achievement/first_win.png";
  static const firstWinTicTacToe =
      "assets/image/achievement/first_tic_tac_toe.png";
  static const firstWinConnectFour =
      "assets/image/achievement/first_connect_four.png";
  static const firstWinDixit = "assets/image/achievement/first_dixit.png";
  static const first10Games = "assets/image/achievement/first_10.png";
  static const first10Wins = "assets/image/achievement/win_10.png";
  static const first50Games = "assets/image/achievement/first_50.png";
  static const first50Wins = "assets/image/achievement/win_50.png";
  static const first100Games = "assets/image/achievement/first_100.png";
  static const first100Wins = "assets/image/achievement/win_100.png";
  static const placeholder = "assets/image/achievement/first_run.png";
}

class AchievementBadge {
  final Achievement achievement;

  title(locale) => achievement.title(locale);

  get image => achievement.image;

  AchievementBadge({
    required this.achievement,
  });

  factory AchievementBadge.fromAchievement(Achievement achievement) {
    return AchievementBadge(
      achievement: achievement,
    );
  }
}
