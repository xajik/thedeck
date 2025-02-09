/*
 *
 *  *
 *  * Created on 5 4 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/actions/game/redux_actions_dixit_game.dart';
import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/games/dixit/redux_middleware_dixit_game_client.dart';
import '../../../../redux/middleware/games/reduxt_middleware_game.dart';
import '../base_game_view_model.dart';

class DixitScreenViewModel extends BaseGameViewModel {
  final DixitGameField? gameField;
  final List<GameParticipant> participants;
  final List<DixitGamePlayer> players;
  final String? userId;
  final Function(List<DixitGameCard>) _makeTurn;
  final Function(String, List<DixitGameCard>) _tellStory;
  final Function(DixitScreenViewModel vm) pushLeaderboardDialog;
  final Function(DixitScreenViewModel vm) pushMapDialog;
  final Function() leaveGame;
  final Function(String url, String fallback) pushFullScreenImage;
  final Function() startNewRound;
  final List<DixitGameCard> roundCards;
  final int selectedCardIndex;
  final Function(int) selectCardIndex;

  get isPlayer => userId != null;

  get isStoryTeller => userId == gameField?.storyteller;

  get roundState => gameField?.roundState;

  @override
  get isGameOver => gameField?.isGameOver ?? false;

  get playerVotedForCard =>
      gameField?.round.playersVote.containsKey(userId) ?? false;

  get playerSelectedCard =>
      gameField?.round.playerSelectedCards.containsKey(userId) ?? false;

  DixitScreenViewModel(
    this.gameField,
    this.participants,
    this.players,
    this.userId,
    this._makeTurn,
    this._tellStory,
    this.startNewRound,
    this.pushLeaderboardDialog,
    this.pushMapDialog,
    this.pushFullScreenImage,
    this.roundCards,
    this.selectedCardIndex,
    this.selectCardIndex,
    this.leaveGame,
    Store<AppState> store,
  ) : super(store);

  factory DixitScreenViewModel.create(Store<AppState> store) {
    final screenState = store.state.dixitGameScreenState;
    final players = screenState?.board.players ?? [];
    final field = screenState?.board.gameField;
    final userId = screenState?.userId;
    final participants = screenState?.room.participants ?? [];

    makeTurn(List<DixitGameCard> cards) {
      if (userId != null) {
        final move = DixitGameMove(userId, cards);
        store.dispatch(middlewareDixitClientMove(move));
      }
    }

    tellStory(String story, List<DixitGameCard> cards) {
      if (userId != null) {
        final move = DixitGameMove(userId, cards, story);
        store.dispatch(middlewareDixitClientMove(move));
      }
    }

    startNewRound() {
      if (userId != null) {
        final move = DixitGameMove(userId, []);
        store.dispatch(middlewareDixitClientMove(move));
      }
    }

    pushLeaderboardDialog(DixitScreenViewModel vm) {
      store.dispatch(middlewareDixitLeaderboard(vm));
    }

    pushMapDialog(DixitScreenViewModel vm) {
      store.dispatch(middlewareDixitMap(vm));
    }

    pushFullScreenImage(String url, String fallback) {
      store.dispatch(middlewareDixitCardPreview(url, fallback));
    }

    List<DixitGameCard> roundCards = userId == null
        ? _getObserverRoundCards(field)
        : _getRoundCards(field, userId);
    final selectedCardIndex =
        store.state.dixitGameScreenState?.selectedCardIndex ?? 0;

    selectCardIndex(int index) {
      store.dispatch(DixitGameChangeCardIndexAction(index));
    }

    leaveGame() {
      store.dispatch(middlewareLeaveGame());
    }

    return DixitScreenViewModel(
      field,
      participants,
      players,
      userId,
      makeTurn,
      tellStory,
      startNewRound,
      pushLeaderboardDialog,
      pushMapDialog,
      pushFullScreenImage,
      roundCards,
      selectedCardIndex,
      selectCardIndex,
      leaveGame,
      store,
    );
  }

  makeTurn() {
    var card = roundCards[selectedCardIndex];
    _makeTurn([card]);
  }

  tellStory(String story) {
    var card = roundCards[selectedCardIndex];
    _tellStory(story, [card]);
  }

  String? userNickName(String? userId) {
    if (userId == null) {
      return null;
    }
    return participants.where((v) => v.userId == userId).first.profile.nickname;
  }

  bool isStoryTellerCard(DixitGameCard card) {
    return card == gameField?.round.storyTellerCard?.card;
  }

  String? cardOwnerNick(DixitGameCard card) {
    if (gameField?.round.storyTellerCard?.card == card) {
      return userNickName(gameField?.round.storyTellerCard?.userId);
    }
    final owner = gameField?.round.playerSelectedCards.entries
        .where((e) => e.value.contains(card))
        .first;
    if (owner != null) {
      return userNickName(owner.key);
    }
    return null;
  }

  List<String> cardVoters(DixitGameCard card) {
    final voters = gameField?.round.playersVote.entries
        .where((e) => e.value.contains(card))
        .map((e) => userNickName(e.key) ?? '')
        .toList();
    return voters ?? [];
  }
}

List<DixitGameCard> _getObserverRoundCards(DixitGameField? field) {
  List<DixitGameCard> cards = [];
  final roundState = field?.roundState;
  //DixitGameRoundState.storytellerChoosingCard & DixitGameRoundState.playersChoosingCard = empty list
  if (roundState == DixitGameRoundState.playersVote) {
    cards.addAll(field?.round.cardsForVote ?? []);
  } else if (roundState == DixitGameRoundState.roundEnded) {
    cards.addAll(field?.round.cardsForVote ?? []);
  }
  return cards;
}

List<DixitGameCard> _getRoundCards(DixitGameField? field, String? userId) {
  List<DixitGameCard> cards = [];
  final roundState = field?.roundState;
  final isStoryTeller = userId == field?.storyteller;
  if (roundState == DixitGameRoundState.storytellerChoosingCard) {
    cards.addAll(field?.handCards[userId] ?? []);
  } else if (roundState == DixitGameRoundState.playersChoosingCard) {
    if (isStoryTeller) {
      cards.add(field?.storytellerCard.card);
    } else if (field?.round.playerSelectedCards.containsKey(userId) ?? false) {
      cards.addAll(field?.round.playerSelectedCards[userId] ?? []);
    } else {
      cards.addAll(field?.handCards[userId] ?? []);
    }
  } else if (roundState == DixitGameRoundState.playersVote) {
    if (isStoryTeller) {
      cards.add(field?.storytellerCard.card);
    } else if (field?.round.playersVote.containsKey(userId) ?? false) {
      cards.addAll(field?.round.playersVote[userId] ?? []);
    } else {
      cards.addAll(_playerVoteCardsList(field, userId));
    }
  } else if (roundState == DixitGameRoundState.roundEnded) {
    cards.addAll(field?.round.cardsForVote ?? []);
  }
  return cards;
}

List<DixitGameCard> _playerVoteCardsList(
    DixitGameField? field, String? userId) {
  List<DixitGameCard> list = [
    ...field?.round.cardsForVote
            .where((entry) =>
                field.round.playerSelectedCards[userId]?.contains(entry) ==
                false)
            .toList() ??
        [],
  ];
  return list;
}
