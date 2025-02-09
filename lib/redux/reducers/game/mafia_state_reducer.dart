/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

part of '../app_reducer.dart';

Reducer<MafiaGameScreenState> _mafiaGameReducer =
    combineReducers<MafiaGameScreenState>([
  TypedReducer<MafiaGameScreenState, MafiaGameReplaceFieldAction>(
      _mafiaFieldReducer),
  TypedReducer<MafiaGameScreenState, MafiaGameToggleShowRoleAction>(
      _mafiaToggleShowRoleAction),
  TypedReducer<MafiaGameScreenState, MafiaGameSelectedPlayerAction>(
      _mafiaSelectedPlayerAction),
]);

MafiaGameScreenState _mafiaFieldReducer(
    MafiaGameScreenState state, MafiaGameReplaceFieldAction action) {
  final board = state.room.board.copyWith(gameField: action.field);
  final room = state.room.copyWith(board: board);
  return state.copyWith(room: room);
}

MafiaGameScreenState _mafiaToggleShowRoleAction(
    MafiaGameScreenState state, MafiaGameToggleShowRoleAction action) {
  return state.copyWith(showRoleVisible: action.isVisible);
}

MafiaGameScreenState _mafiaSelectedPlayerAction(
    MafiaGameScreenState state, MafiaGameSelectedPlayerAction action) {
  final index = action.index;
  if (index == null) {
    return state.copyRemovePlayer();
  }
  return state.copyWith(selectedPlayerCarouselIndex: index);
}

//New Game

Reducer<MafiaGameScreenState?> _mafiaNewGameReducer =
    combineReducers<MafiaGameScreenState?>([
  TypedReducer<MafiaGameScreenState?, MafiaGameReplaceRoomAction>(
      _mafiaNewRoomReducer),
]);

MafiaGameScreenState _mafiaNewRoomReducer(
    MafiaGameScreenState? state, MafiaGameReplaceRoomAction action) {
  return MafiaGameScreenState(
    action.userId,
    action.room,
    false,
    null,
  );
}
