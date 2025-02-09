/*
 *
 *  *
 *  * Created on 5 4 2023
 *
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/redux/app_state.dart';
import 'package:the_deck/ui/style/color_utils.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/title_toolbar_widget.dart';
import '../base_game_screen_widget.dart';
import 'dixit_screen_localisation.dart';
import 'dixit_screen_view_model.dart';

class DixitScreenWidget extends BaseGameScreenWidget {
  static const route = "game/dixit";

  const DixitScreenWidget({Key? key, bool canPop = false})
      : super(key: key, canPop: canPop);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DixitScreenViewModel>(
      converter: (Store<AppState> store) => DixitScreenViewModel.create(store),
      builder: (BuildContext context, DixitScreenViewModel vm) {
        final screenSize = MediaQuery.of(context).size;
        final textTheme = context.textTheme();
        final localisation =
            DixitScreenLocalisatoin(context.appLocalizations());
        return popBody(
          vm: vm,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleToolbarWidget(
                    title: localisation.dixit,
                    actions: [
                      ToolbarMenuAction(
                        icon: Icons.leaderboard,
                        onPressed: () => _showLeaderboard(vm),
                      ),
                      // ToolbarMenuAction(
                      //   icon: Icons.map,
                      //   onPressed: () => _showMap(vm),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGameState(vm, localisation, textTheme),
                  const SizedBox(height: 16),
                  _buildField(vm, localisation, textTheme, screenSize),
                  const SizedBox(height: 16),
                  vm.isPlayer
                      ? _buildAction(vm, localisation, textTheme)
                      : const SizedBox.shrink(),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLeaderboard(DixitScreenViewModel vm) {
    vm.pushLeaderboardDialog(vm);
  }

  Widget _buildField(
    DixitScreenViewModel vm,
    DixitScreenLocalisatoin localisation,
    TextTheme textTheme,
    Size screenSize,
  ) {
    final roundCards = vm.roundCards;
    if (vm.isPlayer == false) {
      if (roundCards.isEmpty) {
        return const SizedBox.shrink();
      }
      var height = screenSize.height / 3;
      return Flexible(
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: height,
              mainAxisSpacing: _Constants.gridPadding,
              crossAxisSpacing: _Constants.gridPadding,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return _cardTile(roundCards[index], textTheme, vm, localisation);
            },
            itemCount: roundCards.length,
          ),
        ),
      );
    }
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 7,
                enlargeFactor: 0.2,
                enlargeCenterPage: true,
                initialPage: vm.selectedCardIndex,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                height: double.infinity,
                onPageChanged: (index, reason) {
                  vm.selectCardIndex(index);
                },
              ),
              items: roundCards.map((card) {
                return _cardTile(card, textTheme, vm, localisation);
              }).toList(),
            ),
          ),
          _listAgenda(vm),
        ],
      ),
    );
  }

  Widget _cardTile(
    DixitGameCard card,
    TextTheme textTheme,
    DixitScreenViewModel vm,
    DixitScreenLocalisatoin localisation,
  ) {
    var gradient = _Constants.blackGradientColor;
    String? cardTopText;
    var cardBottomText = card.cardText;
    if (vm.roundState == DixitGameRoundState.roundEnded) {
      if (vm.isStoryTellerCard(card)) {
        gradient = _Constants.greenGradientColor;
      } else {
        gradient = _Constants.redGradientColor;
      }
      cardTopText = vm.cardOwnerNick(card);
      final voters = vm.cardVoters(card);
      cardBottomText =
          "${localisation.votes} \n ${voters.isEmpty ? localisation.none : voters.join(", ")}";
    }
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: GestureDetector(
            onTap: () => vm.pushFullScreenImage(
              card.cardImage,
              _Constants.cardBackPlaceholder,
            ),
            child: Hero(
              tag: card.cardImage,
              child: CachedNetworkImage(
                imageUrl: card.cardImage,
                fit: BoxFit.cover,
                width: 1000,
                imageBuilder: (context, imageProvider) => Stack(children: [
                  Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  cardTopText == null
                      ? const SizedBox.shrink()
                      : _cardTileText(gradient, cardTopText, textTheme,
                          top: 0.0),
                  _cardTileText(gradient, cardBottomText, textTheme,
                      bottom: 0.0),
                ]),
                placeholder: (context, url) =>
                    Image.asset(_Constants.cardBackPlaceholder),
                errorWidget: (context, url, error) =>
                    Image.asset(_Constants.cardBackPlaceholder),
              ),
            ),
          )),
    );
  }

  Positioned _cardTileText(Color gradient, cardText, TextTheme textTheme,
      {double? top, double? bottom}) {
    return Positioned(
      bottom: bottom,
      top: top,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bottom == null ? AppColors.transparent : gradient,
              bottom == null ? gradient : AppColors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: _Constants.cardTileTextPaddingVertical,
          horizontal: _Constants.cardTileTextPaddingHorizontal,
        ),
        child: Text(
          '$cardText',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _listAgenda(DixitScreenViewModel vm) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: vm.roundCards.asMap().entries.map((entry) {
          return Container(
            width: _Constants.listAgendaSize,
            height: _Constants.listAgendaSize,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(
                    vm.selectedCardIndex == entry.key ? 0.9 : 0.4)),
          );
        }).toList());
  }

  _buildGameState(
    DixitScreenViewModel vm,
    DixitScreenLocalisatoin localisation,
    TextTheme textTheme,
  ) {
    String text = localisation.waitingForHost;
    if (vm.roundState == DixitGameRoundState.storytellerChoosingCard) {
      if (vm.isStoryTeller) {
        text = localisation.tellAStory;
      } else {
        text = localisation.waitingForAStory;
      }
    } else if (vm.roundState == DixitGameRoundState.playersChoosingCard) {
      if (vm.isStoryTeller || vm.playerSelectedCard) {
        text = localisation.playersSelectingCards;
      } else {
        text = localisation.selectACard;
      }
    } else if (vm.roundState == DixitGameRoundState.playersVote) {
      if (vm.isStoryTeller || vm.playerVotedForCard) {
        text = localisation.playersVotingForCards;
      } else {
        text = localisation.voteForACard;
      }
    } else if (vm.roundState == DixitGameRoundState.roundEnded) {
      if (vm.isGameOver) {
        text = localisation.gameOver;
      } else {
        text = localisation.roundIsOver;
      }
    }

    return Center(
      child: Text(
        text,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _buildAction(DixitScreenViewModel vm, DixitScreenLocalisatoin localisation,
      TextTheme textTheme) {
    String? text;
    VoidCallback? onPressed;
    if (vm.roundState == DixitGameRoundState.storytellerChoosingCard) {
      if (vm.isStoryTeller) {
        text = localisation.start;
        onPressed = () {
          vm.tellStory("");
        };
      }
    } else if (vm.roundState == DixitGameRoundState.playersChoosingCard) {
      if (!vm.isStoryTeller && !vm.playerSelectedCard) {
        text = localisation.select;
        onPressed = () {
          vm.makeTurn();
        };
      }
    } else if (vm.roundState == DixitGameRoundState.playersVote) {
      if (!vm.isStoryTeller && !vm.playerVotedForCard) {
        text = localisation.vote;
        onPressed = () {
          vm.makeTurn();
        };
      }
    } else if (vm.roundState == DixitGameRoundState.roundEnded) {
      if (!vm.isGameOver) {
        text = localisation.nextRound;
        onPressed = () {
          vm.startNewRound();
        };
      } else {
        text = localisation.gameOver;
        onPressed = null;
      }
    }
    if (text == null) return const SizedBox.shrink();
    return Center(
      child: CustomElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textTheme.titleMedium?.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

mixin _Constants {
  static const blackGradientColor = Color.fromARGB(200, 0, 0, 0);

  static const greenGradientColor = Color.fromARGB(200, 53, 224, 39);

  static const redGradientColor = Color.fromARGB(200, 239, 58, 58);

  static const listAgendaSize = 12.0;

  static const cardTileTextPaddingVertical = 10.0;

  static const cardTileTextPaddingHorizontal = 20.0;

  static const gridPadding = 8.0;

  static const cardBackPlaceholder = 'assets/image/cards/back.jpg';
}
