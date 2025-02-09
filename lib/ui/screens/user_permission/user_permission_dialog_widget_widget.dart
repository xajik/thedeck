/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-05-21 
 */

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../redux/app_state.dart';
import '../../../redux/middleware/redux_middleware_user_permission.dart';
import '../../style/color_utils.dart';
import '../../widgets/custom_elevated_button.dart';
import 'user_permission_dialog_widget_view_model.dart';
import 'user_permission_dialog_widget_localisation.dart';

class UserPermissionDialogScreenWidget extends StatelessWidget {
  static const route = '/user_permission_dialog_widget';

  const UserPermissionDialogScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserPermissionDialogViewModel>(
      converter: (Store<AppState> store) =>
          UserPermissionDialogViewModel.create(store),
      onDispose: (Store<AppState> store) => store.dispatch(
        middlewareUserPermissionLocalNetwork(),
      ),
      builder: (BuildContext context, UserPermissionDialogViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final UserPermissionDialogLocalisation locale =
            UserPermissionDialogLocalisation(context.appLocalizations());
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_Constants.dialogCorner),
          ),
          title: Text(
            locale.userPermission,
            style: context
                .textTheme()
                .titleMedium
                ?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            locale.localNetworkPermission,
            style: textTheme.titleSmall?.copyWith(color: AppColors.black),
          ),
          actions: <Widget>[
            CustomElevatedButton(
              width: _Constants.buttonWidth,
              onPressed: () => vm.popScreen(),
              child: Text(
                locale.ok.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

mixin _Constants {
  static const double dialogCorner = 16.0;
  static const double buttonWidth = 96;
}
