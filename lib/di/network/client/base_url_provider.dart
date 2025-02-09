/*
 *
 *  *
 *  * Created on 6 5 2023
 *
 */

import 'package:flutter/foundation.dart';

class ApiUrlProvider {
  String get baseUrl =>
      kDebugMode ? _Constants._baseUrlDebug : _Constants._baseUrlProd;

  String get baseAssetsUrl =>
      _Constants._baseUrlProd + _Constants._baseAssetsUrl;

  String get baseDxitAssetsUrl =>
      baseAssetsUrl + _Constants._baseDixitAssetsUrl;
}

mixin _Constants {
  static const _baseAssetsUrl = '/assets';
  static const _baseDixitAssetsUrl = '/dixit/';
  static const _baseUrlProd = "https://getthedeck.com";
  static const _baseUrlDebug = "http://192.168.0.130";
}
