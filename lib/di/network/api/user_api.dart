/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:dio/dio.dart';

class UserApi {
  final Dio _client;

  UserApi(this._client);

  Future<String> newUser(String ulid, String nickName) {
    return Future.value("");
  }
}
