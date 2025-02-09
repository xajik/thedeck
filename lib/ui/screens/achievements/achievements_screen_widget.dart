/*
 *
 *  *
 *  * Created on 23 4 2023
 *  
 */

import '../../../dto/achievement_dto.dart';
import '../../../redux/app_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../di/device_type.dart';
import '../../localisation/achievement_localisation.dart';
import '../../style/color_utils.dart';
import '../../widgets/title_toolbar_widget.dart';
import 'achievements_screen_localization.dart';
import 'achievements_screen_view_model.dart';

class AchievementsScreenWidget extends StatelessWidget {
  static const route = "/achievements";

  const AchievementsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AchievementsScreenViewModel>(
      converter: (store) => AchievementsScreenViewModel.fromStore(store),
      builder: (BuildContext context, AchievementsScreenViewModel vm) {
        final textTheme = context.textTheme();
        final localization =
            AchievementsScreenLocalisation(context.appLocalizations());
        final achievementsLocale =
            AchievementLocalization(context.appLocalizations());
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleToolbarWidget(
                  title: localization.achievements,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.25,
                    children: List.generate(vm.achievements.length, (index) {
                      final achievement = vm.achievements[index];
                      return _buildGridTile(
                        vm,
                        localization,
                        textTheme,
                        achievementsLocale,
                        achievement,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridTile(
    AchievementsScreenViewModel vm,
    AchievementsScreenLocalisation localization,
    TextTheme textTheme,
    AchievementLocalization locale,
    AchievementBadge achievement,
  ) {
    return Container(
      margin: const EdgeInsets.all(_Constants.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Image.asset(
              achievement.image,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            achievement.title(locale),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.purpleDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

mixin _Constants {
  static const tileAchievementIcon = 148.0;
  static const paddingSmall = 8.0;
}
