/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

enum MafiaGamePhase {
  night, //one by one
  night_summary, //summary of the night
  day, //voting
  day_summary; //summary of the day

  static MafiaGamePhase fromName(String name) {
    return MafiaGamePhase.values.firstWhere((e) => e.name == name);
  }
}

extension MafiaGamePhaseExtension on MafiaGamePhase {
  String summary(locale) {
    switch (this) {
      case MafiaGamePhase.night:
        return locale.nightPhaseDescription;
      case MafiaGamePhase.night_summary:
        return locale.nightSummaryPhaseDescription;
      case MafiaGamePhase.day:
        return locale.dayPhaseDescription;
      case MafiaGamePhase.day_summary:
        return locale.daySummaryPhaseDescription;
      default:
        return "";
    }
  }
}

enum MafiaPlayerRole {
  mafia,
  detective,
  doctor,
  lawyer,
  citizen;

  static MafiaPlayerRole fromName(String name) {
    return MafiaPlayerRole.values.firstWhere((e) => e.name == name);
  }
}

extension MafiaPlayerRoleExtension on MafiaPlayerRole {
  String title(locale) {
    switch (this) {
      case MafiaPlayerRole.mafia:
        return locale.mafia;
      case MafiaPlayerRole.detective:
        return locale.detective;
      case MafiaPlayerRole.doctor:
        return locale.doctor;
      case MafiaPlayerRole.lawyer:
        return locale.lawyer;
      case MafiaPlayerRole.citizen:
        return locale.citizen;
      default:
        return locale.citizen;
    }
  }

  MafiaPlayerAbility get ability {
    switch (this) {
      case MafiaPlayerRole.mafia:
        return MafiaPlayerAbility.kill;
      case MafiaPlayerRole.detective:
        return MafiaPlayerAbility.jail;
      case MafiaPlayerRole.doctor:
        return MafiaPlayerAbility.heal;
      case MafiaPlayerRole.lawyer:
        return MafiaPlayerAbility.immunity;
      default:
        return MafiaPlayerAbility.none;
    }
  }

  int get priority {
    switch (this) {
      case MafiaPlayerRole.mafia:
        return 1;
      case MafiaPlayerRole.detective:
        return 2;
      case MafiaPlayerRole.doctor:
        return 3;
      case MafiaPlayerRole.lawyer:
        return 4;
      default:
        return 0;
    }
  }
}

enum MafiaPlayerAbility {
  kill,
  jail,
  heal,
  immunity,
  none;

  static MafiaPlayerAbility fromName(String name) {
    return MafiaPlayerAbility.values.firstWhere((e) => e.name == name);
  }

  int get priority {
    switch (this) {
      case MafiaPlayerAbility.heal:
        return 1;
      case MafiaPlayerAbility.kill:
        return 2;
      case MafiaPlayerAbility.jail:
        return 3;
      default:
        return 5;
    }
  }

  String title(locale) {
    switch (this) {
      case MafiaPlayerAbility.heal:
        return locale.heal;
      case MafiaPlayerAbility.kill:
        return locale.kill;
      case MafiaPlayerAbility.jail:
        return locale.jail;
      case MafiaPlayerAbility.immunity:
        return locale.immunity;
      default:
        return locale.select;
    }
  }
}
