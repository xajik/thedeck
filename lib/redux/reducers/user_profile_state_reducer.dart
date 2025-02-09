/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

part of 'app_reducer.dart';

Reducer<UserProfileScreenState> _userProfileScreenStateReducer =
    combineReducers<UserProfileScreenState>([
  TypedReducer<UserProfileScreenState, LoadedUserProfile>(
    _userLoadedProfileReducer,
  ),
  TypedReducer<UserProfileScreenState, CleanUserProfile>(
    _cleanLoadedProfileReducer,
  ),
]);

UserProfileScreenState _userLoadedProfileReducer(
    UserProfileScreenState state, LoadedUserProfile action) {
  return state.copyWith(userProfile: action.userProfile);
}

UserProfileScreenState _cleanLoadedProfileReducer(
    UserProfileScreenState state, CleanUserProfile action) {
  return UserProfileScreenState.empty();
}
