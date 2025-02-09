/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:the_deck/di/network/client/base_url_provider.dart';
import 'package:the_deck/di/network/download/assets_manager.dart';
import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_server/the_deck_server.dart';

import '../ui/route/screen_router.dart';
import '../usecases/replay_game_usecase.dart';
import 'build_info.dart';
import 'analytics.dart';
import 'db/dao/database_dao.dart';
import 'db/database.dart';
import 'device_information.dart';
import 'files/directory_manager.dart';
import 'files/game_log_file_manager.dart';
import 'lifecycle_state_listener.dart';
import 'logger.dart';
import 'network/api/api_service.dart';
import 'network/client/network_client.dart';
import 'push_notificatoin_handler.dart';

class AppDependency {
  final BuildInfo buildInfo;
  final Analytics analytics;
  final ApiService api;
  final DatabaseDao dao;
  final ScreenRouter router;
  final Logger logger;
  final GameSocketServer gameSocketServer;
  final GameSocketClient gameSocketClient;
  final DeviceInformation deviceInfo;
  final DirectoryManager directoryManager;
  final AssetsFileManager assetsFileManager;
  final ApiUrlProvider apiUrlProvider;

  // final PushNotificationHandler pushNotificationHandler;
  final GameLogFileManager gameLogFileManager;
  final NetworkInfo networkInfo;
  final Connectivity connectivity;
  final LifecycleState lifecycleState;
  final ReplayGameUsecase replayGameUsecase;

  AppDependency({
    required this.buildInfo,
    required this.analytics,
    required this.api,
    required this.dao,
    required this.router,
    required this.logger,
    required this.gameSocketServer,
    required this.gameSocketClient,
    required this.deviceInfo,
    required this.directoryManager,
    required this.assetsFileManager,
    required this.apiUrlProvider,
    // required this.pushNotificationHandler,
    required this.gameLogFileManager,
    required this.networkInfo,
    required this.lifecycleState,
    required this.connectivity,
    required this.replayGameUsecase,
  });
}

mixin AppDependencyProvider {
  static Future<AppDependency> create() async {
    final logger = Logger();
    final stopWatch = Stopwatch()..start();
    final dateTime = DateTime.now();
    logger.d("Create at $dateTime", tag: Constants.tag);
    final analytics = await Analytics().init();
    logger.d("analytics, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final buildInfo = await BuildInformationProvider.buildInfo;
    logger.d("buildInfo, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final apiUrlProvider = ApiUrlProvider();
    final api = _api(buildInfo, logger, apiUrlProvider);
    logger.d("API, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final dao = await _db();
    logger.d("DB, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final router = ScreenRouter(logger);
    logger.d("router, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final gameSocketServer = GameSocketServer.create(logger);
    logger.d("gameSocketServer, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final gameSocketClient = GameSocketClient.create(logger);
    logger.d("gameSocketClient, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final deviceInformation = DeviceInformation.create();
    logger.d("deviceInformation, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final directoryManager = DirectoryManager();
    logger.d("directoryManager, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final assetsFileManager = AssetsFileManager(
      api.assetsApi,
      dao.assetsEntityDao,
      directoryManager,
      logger,
    );
    logger.d("assetsFileManager, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    // final pushNotificationHandler =
    //     await _pushNotificationHandler(logger, analytics);
    final gameLogFileManager = GameLogFileManager(directoryManager, logger);
    logger.d("gameLogFileManager, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final networkInfo = NetworkInfo();
    logger.d("networkInfo, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final lifecycleState = LifecycleState();
    logger.d("lifecycleState, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final connectivity = Connectivity();
    logger.d("connectivity, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    final replayGameUsecase = ReplayGameUsecase(logger, gameLogFileManager);
    logger.d("replayGameUsecase, elapsed ${stopWatch.elapsedMilliseconds}",
        tag: Constants.tag);
    stopWatch.stop();
    logger.d("Done at ${stopWatch.elapsedMilliseconds}", tag: Constants.tag);
    return AppDependency(
      analytics: analytics,
      buildInfo: buildInfo,
      api: api,
      dao: dao,
      router: router,
      logger: logger,
      gameSocketServer: gameSocketServer,
      gameSocketClient: gameSocketClient,
      deviceInfo: deviceInformation,
      directoryManager: directoryManager,
      assetsFileManager: assetsFileManager,
      apiUrlProvider: apiUrlProvider,
      // pushNotificationHandler: pushNotificationHandler,
      gameLogFileManager: gameLogFileManager,
      networkInfo: networkInfo,
      lifecycleState: lifecycleState,
      connectivity: connectivity,
      replayGameUsecase: replayGameUsecase,
    );
  }

  static ApiService _api(
    BuildInfo buildInfo,
    Logger logger,
    ApiUrlProvider apiUrlProvider,
  ) {
    final networkClient =
        NetworkClientBuilder.create(buildInfo, logger, apiUrlProvider);
    final api = ApiService.build(client: networkClient);
    return api;
  }

  static Future<DatabaseDao> _db() async {
    final db = await Database.create();
    final dao = DatabaseDao(db);
    return dao;
  }

  static Future<PushNotificationHandler> _pushNotificationHandler(
    Logger logger,
    Analytics analytics,
  ) async {
    final pushNotificationHandler = PushNotificationHandler(logger, analytics);
    //TODO add support
    // await pushNotificationHandler.setup();
    // pushNotificationHandler.listenForeground();
    return pushNotificationHandler;
  }
}

mixin Constants {
  static const tag = "AppDependencyProvider";
}
