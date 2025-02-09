/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:the_deck/di/db/entity/user_profile_entity.dart';

import '../../../dto/achievement_dto.dart';
import '../../../redux/app_state.dart';

class LeaderboardScreenViewModel {
  final List<UserProfileEntity> leaderboard;

  LeaderboardScreenViewModel(this.leaderboard);

  factory LeaderboardScreenViewModel.fromStore(Store<AppState> store) {
    final leaderboard = store.state.homeScreenState.leaderboard;
    return LeaderboardScreenViewModel(leaderboard);
  }
}
