/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:redux/redux.dart';

import '../../../dto/achievement_dto.dart';
import '../../../redux/app_state.dart';

class AchievementsScreenViewModel {
  final List<AchievementBadge> achievements;

  AchievementsScreenViewModel(this.achievements);

  factory AchievementsScreenViewModel.fromStore(Store<AppState> store) {
    final achievements = store.state.homeScreenState.achievements;
    return AchievementsScreenViewModel(achievements);
  }
}
