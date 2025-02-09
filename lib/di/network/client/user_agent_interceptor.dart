/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */


import 'dart:io';

import 'package:dio/dio.dart';

import '../../build_info.dart';

class UserAgentInterceptor extends Interceptor {
  final BuildInfo _appInfo;
  late final String? _userAgent = _appInfo.userAgent();

  UserAgentInterceptor(this._appInfo);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_userAgent?.isNotEmpty == true) {
      options.headers[HttpHeaders.userAgentHeader] = _userAgent;
    }
    return super.onRequest(options, handler);
  }
}
