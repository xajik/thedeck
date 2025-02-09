/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'state/games/connect_four_game_screen_state.dart';
import 'state/games/dixit_game_screen_state.dart';
import 'state/games/tic_tac_toe_game_screen_state.dart';
import 'state/games/mafia_game_screen_state.dart';
import 'state/home_screen_state.dart';
import 'state/replay_game_state.dart';
import 'state/room_connect_state.dart';
import 'state/room_create_state.dart';
import 'state/user_profile_screen_state.dart';
import 'state/user_state.dart';

class AppState {
  final RoomCreateState roomCreate;
  final RoomConnectState roomConnect;
  final UserState userState;
  final UserProfileScreenState userProfileScreenState;
  final HomeScreenState homeScreenState;
  final ReplayGameState replayGameState;

  //Games
  final TicTacToeGameScreenState? ticTacToeGameScreenState;
  final ConnectFourGameScreenState? connectFourGameScreenState;
  final DixitGameScreenState? dixitGameScreenState;
  final MafiaGameScreenState? mafiaGameScreenState;

  AppState({
    required this.roomCreate,
    required this.roomConnect,
    required this.userState,
    required this.userProfileScreenState,
    required this.homeScreenState,
    required this.replayGameState,
    required this.ticTacToeGameScreenState,
    required this.connectFourGameScreenState,
    required this.dixitGameScreenState,
    required this.mafiaGameScreenState,
  });

  AppState.create()
      : roomCreate = RoomCreateState.empty(),
        roomConnect = RoomConnectState.empty(),
        userState = UserState.empty(),
        userProfileScreenState = UserProfileScreenState.empty(),
        homeScreenState = HomeScreenState.empty(),
        replayGameState = ReplayGameState.empty(),
        //Games
        ticTacToeGameScreenState = null,
        connectFourGameScreenState = null,
        dixitGameScreenState = null,
        mafiaGameScreenState = null;
}
