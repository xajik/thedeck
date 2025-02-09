/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:the_deck/di/db/entity/user_profile_entity.dart';
import 'package:the_deck/redux/middleware/redux_middleware_user_profile.dart';

import '../../../redux/app_state.dart';

class UserProfileScreenViewModel {
  final UserProfileEntity? userProfile;
  final Function(String) loadUser;
  final Function(String) updateNickname;

  UserProfileScreenViewModel._(
    this.loadUser,
    this.userProfile,
    this.updateNickname,
  );

  factory UserProfileScreenViewModel.create(Store<AppState> store) {
    final userProfile = store.state.userProfileScreenState.userProfile;
    loadUser(String userId) {
      store.dispatch(middlewareLoadUserProfile(userId));
    }

    updateNickname(String nickname) {
      final userId = userProfile?.userId;
      if (userId != null) {
        store.dispatch(middlewareUpdateNickname(userId, nickname));
      }
    }

    return UserProfileScreenViewModel._(
      loadUser,
      userProfile,
      updateNickname,
    );
  }
}
