/*
 *
 *  *
 *  * Created on 5 4 2023
 *  
 */

part of '../app_reducer.dart';

Reducer<DixitGameScreenState> _dixitGameReducer =
    combineReducers<DixitGameScreenState>([
  TypedReducer<DixitGameScreenState, DixitGameReplaceFieldAction>(
      _dixitFieldReducer),
  TypedReducer<DixitGameScreenState, DixitGameChangeCardIndexAction>(
      _dixitFieldCardIndexReducer),
]);

DixitGameScreenState _dixitFieldReducer(
    DixitGameScreenState state, DixitGameReplaceFieldAction action) {
  final board = state.board.copyWith(gameField: action.field);
  final room = state.room.copyWith(board: board);
  var newRoundState = action.field.roundState;
  if (newRoundState != state.localRoundState) {
    return state.copyWith(
      room: room,
      selectedCardIndex: 0,
      localRoundState: newRoundState,
    );
  }
  return state.copyWith(room: room);
}

DixitGameScreenState _dixitFieldCardIndexReducer(
    DixitGameScreenState state, DixitGameChangeCardIndexAction action) {
  return state.copyWith(selectedCardIndex: action.index);
}

//New Game

Reducer<DixitGameScreenState?> _dixitNewGameReducer =
    combineReducers<DixitGameScreenState?>([
  TypedReducer<DixitGameScreenState?, DixitNewRoomAction>(_dixitRoomReduced),
]);

DixitGameScreenState _dixitRoomReduced(
    DixitGameScreenState? state, DixitNewRoomAction action) {
  return DixitGameScreenState(action.userId, action.room, 0, null);
}
