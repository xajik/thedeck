/*
 *
 *  *
 *  * Created on 24 6 2023
 *
 */

part of 'app_reducer.dart';

Reducer<ReplayGameState> _replayGameReducers =
    combineReducers<ReplayGameState>([
  TypedReducer<ReplayGameState, ReplayGameLoadAction>(
      _replayGameLogEntityReducers),
  TypedReducer<ReplayGameState, ReplayProgressUpdateAction>(
      _replayReplayProgressUpdateAction),
  TypedReducer<ReplayGameState, ReplayGameClearAction>(
      _replayGameClearReducers),
]);

ReplayGameState _replayGameLogEntityReducers(
    ReplayGameState state, ReplayGameLoadAction action) {
  return state.copyWith(gameLogEntity: action.gameLogEntity);
}

ReplayGameState _replayGameClearReducers(
    ReplayGameState state, ReplayGameClearAction action) {
  return ReplayGameState.empty();
}

ReplayGameState _replayReplayProgressUpdateAction(
    ReplayGameState state, ReplayProgressUpdateAction action) {
  return state.copyWith(
    totalMoves: action.totalMoves,
    movesLeft: action.movesLeft,
  );
}
