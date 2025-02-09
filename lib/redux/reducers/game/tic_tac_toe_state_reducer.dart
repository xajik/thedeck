/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

part of '../app_reducer.dart';

Reducer<TicTacToeGameScreenState> _ticTacToeGameReducer =
    combineReducers<TicTacToeGameScreenState>([
  TypedReducer<TicTacToeGameScreenState, TicTacToeGameReplaceFieldAction>(
      _ticTacToeFieldReducer),
]);

TicTacToeGameScreenState _ticTacToeFieldReducer(
    TicTacToeGameScreenState state, TicTacToeGameReplaceFieldAction action) {
  final board = state.board.copyWith(gameField: action.field);
  return state.copyWith(board: board);
}

//New Game

Reducer<TicTacToeGameScreenState?> _ticTacToeNewGameReducer =
    combineReducers<TicTacToeGameScreenState?>([
  TypedReducer<TicTacToeGameScreenState?, TicTacToeUpdateRoomAction>(
      _ticTacToeRoomReducer),
]);

TicTacToeGameScreenState _ticTacToeRoomReducer(
    TicTacToeGameScreenState? state, TicTacToeUpdateRoomAction action) {
  return TicTacToeGameScreenState(action.userId, action.room);
}
