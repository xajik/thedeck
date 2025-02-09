/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

part of 'app_reducer.dart';

Reducer<RoomConnectState> _roomConnectStateReducer =
    combineReducers<RoomConnectState>([
  TypedReducer<RoomConnectState, RoomSocketClientClosedAction>(
    _roomClientDisposeReducer,
  ),
  TypedReducer<RoomConnectState, RoomSocketClientUpdateDetailsAction>(
    _roomClientAddressReducer,
  ),
  TypedReducer<RoomConnectState, RoomSocketClientRemoveDetailsAction>(
    _roomRemoveDetailsReducer,
  ),
  TypedReducer<RoomConnectState, RoomParticipantsListClientRoomAction>(
    _roomServerListParticipantsReducer,
  ),
  TypedReducer<RoomConnectState, RoomSocketClientFailedAction>(
    _roomConnectFailedReducer,
  ),
  TypedReducer<RoomConnectState, RoomConnectClientWifiAction>(
    _roomConnectWifiNameReducer,
  ),
]);

RoomConnectState _roomClientDisposeReducer(
    RoomConnectState state, RoomSocketClientClosedAction action) {
  return RoomConnectState.empty(state.wifiName);
}

RoomConnectState _roomClientAddressReducer(
    RoomConnectState state, RoomSocketClientUpdateDetailsAction action) {
  return state.copyWith(details: action.details);
}

RoomConnectState _roomRemoveDetailsReducer(
    RoomConnectState state, RoomSocketClientRemoveDetailsAction action) {
  return state.copyWith(details: null);
}

RoomConnectState _roomServerListParticipantsReducer(
    RoomConnectState state, RoomParticipantsListClientRoomAction action) {
  return state.copyWith(participants: action.participants);
}

RoomConnectState _roomConnectFailedReducer(
    RoomConnectState state, RoomSocketClientFailedAction action) {
  return RoomConnectState.empty(state.wifiName);
}

RoomConnectState _roomConnectWifiNameReducer(
    RoomConnectState state, RoomConnectClientWifiAction action) {
  return state.copyWith(wifiName: action.wifiName);
}
