/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import '../../di/db/entity/user_entity.dart';

class UserState {
  final UserEntity? user;

  get userId => user?.getKey();

  UserState({required this.user});

  UserState.empty() : user = null;

  UserState copyWith({UserEntity? user}) {
    return UserState(
      user: user ?? this.user,
    );
  }
}
