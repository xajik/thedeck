/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

part of 'app_reducer.dart';

Reducer<UserState> _userStateReducer = combineReducers<UserState>([
  TypedReducer<UserState, StoreUserAction>(_userLoadedReducer),
]);

UserState _userLoadedReducer(UserState state, StoreUserAction action) {
  return state.copyWith(user: action.user);
}
