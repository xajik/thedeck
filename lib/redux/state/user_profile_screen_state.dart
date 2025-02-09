/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import '../../di/db/entity/user_profile_entity.dart';

class UserProfileScreenState {
  final UserProfileEntity? userProfile;

  UserProfileScreenState(this.userProfile);

  UserProfileScreenState.empty() : userProfile = null;

  UserProfileScreenState copyWith({UserProfileEntity? userProfile}) {
    return UserProfileScreenState(userProfile ?? this.userProfile);
  }
}
