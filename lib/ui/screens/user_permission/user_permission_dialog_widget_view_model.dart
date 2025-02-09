/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-05-21 
 */

import 'package:redux/redux.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';

import '../../../redux/app_state.dart';

class UserPermissionDialogViewModel {
  final Function popScreen;

  UserPermissionDialogViewModel(
    this.popScreen,
  );

  factory UserPermissionDialogViewModel.create(Store<AppState> store) {
    popScreen() {
      store.dispatch(middlewareRouterPop());
    }

    return UserPermissionDialogViewModel(
      popScreen,
    );
  }
}
