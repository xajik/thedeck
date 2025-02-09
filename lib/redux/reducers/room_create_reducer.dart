/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

part of 'app_reducer.dart';

Reducer<RoomCreateState> _roomCreateStateReducer =
    combineReducers<RoomCreateState>([
  TypedReducer<RoomCreateState, RoomCreatedAction>(_roomCreatedReducer),
  TypedReducer<RoomCreateState, RoomDisposeSocketServerAction>(
    _roomSocketDisposeReducer,
  ),
  TypedReducer<RoomCreateState, RoomReadyRoomAction>(
    _roomReadyCreateReducer,
  ),
  TypedReducer<RoomCreateState, RoomParticipantsListClientRoomAction>(
    _roomListParticipantsClientReducer,
  ),
]);

RoomCreateState _roomSocketDisposeReducer(
    RoomCreateState state, RoomDisposeSocketServerAction action) {
  return RoomCreateState.empty();
}

RoomCreateState _roomCreatedReducer(
    RoomCreateState state, RoomCreatedAction action) {
  return state.copyWith(
    roomCreateDetails: action.roomCreateDetails,
    wifiName: action.wifiName,
  );
}

RoomCreateState _roomReadyCreateReducer(
    RoomCreateState state, RoomReadyRoomAction action) {
  return state.copyWith(isReady: action.isReady);
}

RoomCreateState _roomListParticipantsClientReducer(
    RoomCreateState state, RoomParticipantsListClientRoomAction action) {
  return state.copyWith(participants: action.participants);
}
