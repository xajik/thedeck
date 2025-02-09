/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-05-11 
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/ui/widgets/title_toolbar_widget.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../redux/app_state.dart';
import '../../style/dimmension_utils.dart';
import 'help_connect_view_model.dart';
import 'help_connect_localisation.dart';

class HelpConnectScreenWidget extends StatelessWidget {
  static const route = '/help/connect';

  const HelpConnectScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HelpConnectViewModel>(
      converter: (Store<AppState> store) => HelpConnectViewModel.create(store),
      builder: (BuildContext context, HelpConnectViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final HelpConnectLocalisation locale =
            HelpConnectLocalisation(context.appLocalizations());
        final items = [
          Pair.of(Icons.wifi, locale.helpConnect1),
          Pair.of(Icons.close_fullscreen, locale.helpConnect2),
          Pair.of(Icons.qr_code, locale.helpConnect3),
          Pair.of(Icons.apple, locale.iosLocalNetworkPermission),
          Pair.of(Icons.android, locale.androidHotSpot),
        ];
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TitleToolbarWidget(title: locale.helpConnect),
                  ...items
                      .map((e) => _buildTile(
                            locale,
                            textTheme,
                            e.first,
                            e.second,
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildTile(HelpConnectLocalisation locale, TextTheme textTheme,
      IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(Dim.padding),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dim.padding),
            child: Icon(icon),
          ),
        ],
      ),
    );
  }
}
