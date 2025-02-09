/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:the_deck/redux/actions/redux_action_room_create.dart';
import 'package:the_deck/redux/actions/redux_action_user_state.dart';
import 'package:the_deck/redux/actions/game/redux_actions_tic_tac_toe_game.dart';
import 'package:the_deck/redux/actions/reduxt_action_home_screen.dart';
import 'package:the_deck/redux/app_state.dart';
import 'package:the_deck/redux/state/replay_game_state.dart';

import '../actions/game/redux_action_games.dart';
import '../actions/game/redux_actions_connect_four_game.dart';
import '../actions/game/redux_actions_dixit_game.dart';
import '../actions/game/redux_actions_mafia_game.dart';
import '../actions/redux_action_room_connect.dart';
import '../actions/reduxt_action_user_profile.dart';
import '../actions/replay_game_actions.dart';
import '../state/games/connect_four_game_screen_state.dart';
import '../state/games/dixit_game_screen_state.dart';
import '../state/games/mafia_game_screen_state.dart';
import '../state/games/tic_tac_toe_game_screen_state.dart';
import '../state/home_screen_state.dart';
import '../state/room_connect_state.dart';
import '../state/room_create_state.dart';
import '../state/user_profile_screen_state.dart';
import '../state/user_state.dart';

part 'room_create_reducer.dart';

part 'room_connect_reducer.dart';

part 'user_state_reducer.dart';

part 'game/tic_tac_toe_state_reducer.dart';

part 'game/connect_four_state_reducer.dart';

part 'game/dixit_state_reducer.dart';

part 'user_profile_state_reducer.dart';

part 'home_state_reducer.dart';

part 'replay_game_reducer.dart';

part 'game/mafia_state_reducer.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    roomCreate: _roomCreateStateReducer(state.roomCreate, action),
    roomConnect: _roomConnectStateReducer(state.roomConnect, action),
    userState: _userStateReducer(state.userState, action),
    userProfileScreenState: _userProfileScreenStateReducer(
      state.userProfileScreenState,
      action,
    ),
    homeScreenState: _homeStateReducer(state.homeScreenState, action),
    replayGameState: _replayGameReducers(state.replayGameState, action),
    //Games
    ticTacToeGameScreenState: _ticTacToeGameScreenState(state, action),
    connectFourGameScreenState: _connectFourGameScreenState(state, action),
    dixitGameScreenState: _dixitGameScreenState(state, action),
    mafiaGameScreenState: goGameScreenState(state, action),
  );
}

TicTacToeGameScreenState? _ticTacToeGameScreenState(AppState state, action) {
  if (action is ClearAllGamesState) {
    return null;
  }
  var gameState = state.ticTacToeGameScreenState;
  return gameState == null
      ? _ticTacToeNewGameReducer(gameState, action)
      : _ticTacToeGameReducer(gameState, action);
}

ConnectFourGameScreenState? _connectFourGameScreenState(
  AppState state,
  action,
) {
  if (action is ClearAllGamesState) {
    return null;
  }
  var gameState = state.connectFourGameScreenState;
  return gameState == null
      ? _connectFourNewGameReducer(gameState, action)
      : _connectFourGameReducer(gameState, action);
}

DixitGameScreenState? _dixitGameScreenState(AppState state, action) {
  if (action is ClearAllGamesState) {
    return null;
  }
  var gameState = state.dixitGameScreenState;
  return gameState == null
      ? _dixitNewGameReducer(gameState, action)
      : _dixitGameReducer(gameState, action);
}

MafiaGameScreenState? goGameScreenState(AppState state, action) {
  if (action is ClearAllGamesState) {
    //TODO: move to reducer
    return null;
  }
  var gameState = state.mafiaGameScreenState;
  return gameState == null
      ? _mafiaNewGameReducer(gameState, action)
      : _mafiaGameReducer(gameState, action);
}
