/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

part of '../app_reducer.dart';

Reducer<ConnectFourGameScreenState> _connectFourGameReducer =
    combineReducers<ConnectFourGameScreenState>([
  TypedReducer<ConnectFourGameScreenState, ConnectFourGameReplaceFieldAction>(
      _connectFourFieldReducer),
]);

ConnectFourGameScreenState _connectFourFieldReducer(
    ConnectFourGameScreenState state,
    ConnectFourGameReplaceFieldAction action) {
  final board = state.room.board.copyWith(gameField: action.field);
  final room = state.room.copyWith(board: board);
  return state.copyWith(room: room);
}

//New Game

Reducer<ConnectFourGameScreenState?> _connectFourNewGameReducer =
    combineReducers<ConnectFourGameScreenState?>([
  TypedReducer<ConnectFourGameScreenState?, ConnectFourGameReplaceRoomAction>(
      _connectFourNewRoomReducer),
]);

ConnectFourGameScreenState _connectFourNewRoomReducer(
    ConnectFourGameScreenState? state,
    ConnectFourGameReplaceRoomAction action) {
  return ConnectFourGameScreenState(action.userId, action.room);
}
