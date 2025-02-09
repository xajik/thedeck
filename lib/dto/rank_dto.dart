/*
 *
 *  *
 *  * Created on 22 4 2023
 *
 */

enum Rank {
  beginner,
  novice,
  amateur,
  semiPro,
  pro,
  elite,
  legendary,
  master,
  grandMaster,
  godlike
}

extension RankExtension on Rank {
  static Rank getUserRanksFromScore(int score) {
    List<Rank> ranks = Rank.values.reversed.toList();
    for (final r in ranks) {
      if (r.threshold() <= score) {
        return r;
      }
    }
    return Rank.novice;
  }

  String title(locale) {
    switch (this) {
      case Rank.novice:
        return locale.novice;
      case Rank.beginner:
        return locale.beginner;
      case Rank.amateur:
        return locale.amateur;
      case Rank.semiPro:
        return locale.semiPro;
      case Rank.pro:
        return locale.pro;
      case Rank.elite:
        return locale.elite;
      case Rank.legendary:
        return locale.legendary;
      case Rank.master:
        return locale.master;
      case Rank.grandMaster:
        return locale.grandMaster;
      case Rank.godlike:
        return locale.godlike;
      default:
        return locale.novice;
    }
  }

  int threshold() {
    switch (this) {
      case Rank.novice:
        return 50;
      case Rank.beginner:
        return 200;
      case Rank.amateur:
        return 500;
      case Rank.semiPro:
        return 700;
      case Rank.pro:
        return 1000;
      case Rank.elite:
        return 3000;
      case Rank.legendary:
        return 5000;
      case Rank.master:
        return 8000;
      case Rank.grandMaster:
        return 10000;
      case Rank.godlike:
        return 15000;
      default:
        return 50;
    }
  }
}
