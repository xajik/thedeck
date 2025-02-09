/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:dio/dio.dart';
import 'package:the_deck/di/network/api/assets_api.dart';

import 'user_api.dart';

class ApiService {
  final UserApi userApi;
  final AssetsApi assetsApi;

  ApiService({
    required this.userApi,
    required this.assetsApi,
  });

  factory ApiService.build({required Dio client}) {
    return ApiService(
      userApi: UserApi(client),
      assetsApi: AssetsApi(client),
    );
  }
}
