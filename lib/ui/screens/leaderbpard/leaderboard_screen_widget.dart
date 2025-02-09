/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../di/db/entity/user_profile_entity.dart';
import '../../../di/device_type.dart';
import '../../../dto/rank_dto.dart';
import '../../../redux/app_state.dart';
import '../../localisation/rank_localisation.dart';
import '../../style/color_utils.dart';
import '../../style/custom_style_utils.dart';
import '../../widgets/title_toolbar_widget.dart';
import 'leaderboard_screen_localization.dart';
import 'leaderboard_screen_view_model.dart';

class LeaderboardScreenWidget extends StatelessWidget {
  static const route = "/leaderboard";

  const LeaderboardScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LeaderboardScreenViewModel>(
      converter: (store) => LeaderboardScreenViewModel.fromStore(store),
      builder: (BuildContext context, LeaderboardScreenViewModel vm) {
        final textTheme = context.textTheme();
        final localization =
            LeaderboardLocalisation(context.appLocalizations());
        final rankLocale = RankLocalization(context.appLocalizations());
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleToolbarWidget(
                  title: localization.leaderboard,
                ),
                Expanded(
                  child: GridView.count(
                    childAspectRatio: 1 / 1.5,
                    crossAxisCount: 3,
                    children: List.generate(vm.leaderboard.length, (index) {
                      final user = vm.leaderboard[index];
                      return _buildGridTile(
                        vm,
                        localization,
                        textTheme,
                        user,
                        rankLocale,
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
    LeaderboardScreenViewModel vm,
    LeaderboardLocalisation localization,
    TextTheme textTheme,
    UserProfileEntity user,
    RankLocalization rankLocale,
  ) {
    var userImage = user.image;
    return Container(
      margin: const EdgeInsets.all(_Constants.paddingSmall),
      padding: const EdgeInsets.all(_Constants.paddingSmall),
      decoration: gradientRoundedBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(_Constants.paddingSmall),
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child: userImage == null
                        ? Image.asset(
                            _Constants.imageDefaultUser,
                            fit: BoxFit.fitWidth,
                          )
                        : CachedNetworkImage(
                            imageUrl: userImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              _Constants.imageDefaultUser,
                              fit: BoxFit.fitWidth,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              _Constants.imageDefaultUser,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: _Constants.iconBorderWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            user.nickName,
            style: textTheme.titleLarge?.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Text(
            RankExtension.getUserRanksFromScore(user?.score ?? 0)
                .title(rankLocale),
            maxLines: 1,
            style: textTheme.titleMedium?.copyWith(color: AppColors.white),
          ),
          Text(
            user.score.toString(),
            style: textTheme.titleSmall?.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: _Constants.paddingXSmall),
        ],
      ),
    );
  }
}

mixin _Constants {
  static const paddingSmall = 8.0;
  static const paddingXSmall = 4.0;
  static const imageDefaultUser = "assets/image/default_user.png";
  static const iconBorderWidth = 1.0;
}
