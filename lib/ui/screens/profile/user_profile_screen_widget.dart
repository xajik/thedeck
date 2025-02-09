/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/di/db/entity/user_profile_entity.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../di/app_dependency.dart';
import '../../../dto/rank_dto.dart';
import '../../../redux/actions/reduxt_action_user_profile.dart';
import '../../../redux/app_state.dart';
import '../../localisation/rank_localisation.dart';
import '../../style/color_utils.dart';
import '../../style/custom_style_utils.dart';
import '../../widgets/title_toolbar_widget.dart';
import 'user_profile_localisation.dart';
import 'user_profile_screen_view_model.dart';

class UserProfileScreenWidget extends StatefulWidget {
  static const route = "home/userProfile";
  static const userIdKey = "userId";
  final String userId;

  UserProfileScreenWidget({Key? key, required Map<String, dynamic> arguments})
      : userId = arguments[userIdKey],
        super(key: key);

  @override
  State<UserProfileScreenWidget> createState() =>
      _UserProfileScreenWidgetState();
}

class _UserProfileScreenWidgetState extends State<UserProfileScreenWidget> {
  final _nickName = TextEditingController();
  final GlobalKey<FormState> _nickNameKey = GlobalKey<FormState>();
  String? _nickErrorMessage;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserProfileScreenViewModel>(
      converter: (Store<AppState> store) =>
          UserProfileScreenViewModel.create(store),
      onInitialBuild: (vm) => vm.loadUser(widget.userId),
      onDispose: (store) => store.dispatch(CleanUserProfile()),
      builder: (BuildContext context, UserProfileScreenViewModel vm) {
        final analytics =
            Provider.of<AppDependency>(context, listen: false).analytics;
        final textTheme = context.textTheme();
        final locale = UserProfileLocalisation(context.appLocalizations());
        final rankLocale = RankLocalization(context.appLocalizations());
        var userProfile = vm.userProfile;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TitleToolbarWidget(
                  title: locale.userProfile,
                  actions: [
                    ToolbarMenuAction(
                      icon: Icons.save,
                      onPressed: () {
                        analytics.reportSaveNickname();
                        vm.updateNickname(_nickName.text);
                      },
                    ),
                  ],
                ),
                _body(vm, locale, textTheme, userProfile, rankLocale),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(
    UserProfileScreenViewModel vm,
    UserProfileLocalisation localization,
    TextTheme textTheme,
    UserProfileEntity? userProfile,
    RankLocalization rankLocale,
  ) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserHeader(vm, localization, textTheme, userProfile, rankLocale),
        _buildEditNickName(vm, localization, textTheme, userProfile),
      ],
    ));
  }

  Widget _buildUserHeader(
    UserProfileScreenViewModel vm,
    UserProfileLocalisation locale,
    TextTheme textTheme,
    UserProfileEntity? user,
    RankLocalization rankLocale,
  ) {
    var image = user?.image;
    return Container(
      margin: const EdgeInsets.all(_Constants.padding),
      padding: const EdgeInsets.all(_Constants.paddingSmall),
      decoration: gradientRoundedBoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: _Constants.paddingSmall),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white,
                width: _Constants.iconBorderWidth,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: image == null
                    ? Image.asset(
                        _Constants.imageDefaultAvatar,
                        fit: BoxFit.cover,
                      ).image
                    : NetworkImage(image),
                radius: _Constants.iconRadius,
                backgroundColor: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: _Constants.padding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  locale.hiYou(user?.nickName ?? locale.theDeck),
                  style: textTheme.headline4?.copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(height: _Constants.padding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    RankExtension.getUserRanksFromScore(user?.score ?? 0)
                        .title(rankLocale),
                    style:
                        textTheme.titleMedium?.copyWith(color: AppColors.white),
                  ),
                  Text(
                    locale.yourScore(user?.score ?? 0),
                    style:
                        textTheme.titleMedium?.copyWith(color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: _Constants.padding),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditNickName(
      UserProfileScreenViewModel vm,
      UserProfileLocalisation locale,
      TextTheme textTheme,
      UserProfileEntity? userProfile) {
    _nickName.text = userProfile?.nickName ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _Constants.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.nickname,
            textAlign: TextAlign.start,
            style: textTheme.subtitle1?.copyWith(
              color: AppColors.purpleDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: _Constants.paddingSmall),
          SizedBox(
            width: _Constants.maxWidth,
            child: Form(
              key: _nickNameKey,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      _Constants.nickNameRegexpFilter),
                ],
                maxLines: 1,
                maxLength: _Constants.maxLength,
                controller: _nickName,
                onChanged: (value) {
                  _nickNameKey.currentState?.validate();
                },
                decoration: InputDecoration(
                  hintText: locale.nickname,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.grey),
                    borderRadius:
                        BorderRadius.circular(_Constants.borderRadiusSmall),
                    gapPadding: _Constants.paddingSmall,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.indigo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.wrongInputValue;
                  }
                  if (!_Constants.nickNameRegexp.hasMatch(value)) {
                    return locale.wrongInputValue;
                  }
                  return null;
                },
              ),
            ),
          ),
          Text(
            locale.nickNameExplained,
            textAlign: TextAlign.start,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.purpleDark,
            ),
          ),
        ],
      ),
    );
  }
}

mixin _Constants {
  static final nickNameRegexp = RegExp(r'^[a-zA-Z0-9]{6,24}$');
  static final nickNameRegexpFilter = RegExp(r'^[a-zA-Z0-9]+$');

  static const paddingSmall = 4.0;
  static const padding = 16.0;
  static const iconRadius = 72.0;
  static const borderRadiusSmall = 8.0;

  static const iconBorderWidth = 1.0;

  static const imageDefaultAvatar = "assets/image/default_avatar.png";

  static const maxWidth = 500.0;
  static const maxLength = 24;
}
