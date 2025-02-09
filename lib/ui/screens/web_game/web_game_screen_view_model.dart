/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';

class WebGameScreenViewModel {
  WebGameScreenViewModel();

  factory WebGameScreenViewModel.create(Store<AppState> store) {
    return WebGameScreenViewModel();
  }
}
