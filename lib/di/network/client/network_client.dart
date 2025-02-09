/*
 *
 *  *
 *  * Created on 1 4 2023
 *  
 */

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

import 'package:the_deck/di/build_info.dart';
import 'package:the_deck/di/logger.dart';

import 'base_url_provider.dart';
import 'user_agent_interceptor.dart';

mixin NetworkClientBuilder {
  static Dio create(
    BuildInfo buildInfo,
    Logger logger,
    ApiUrlProvider urlProvider,
  ) {
    final userAgentInterceptor = UserAgentInterceptor(buildInfo);

    final options = BaseOptions(
      baseUrl: urlProvider.baseUrl,
      connectTimeout: _Constants.seconds_30,
      receiveTimeout: _Constants.seconds_45,
      followRedirects: true,
      // requestEncoder: _gzipEncoder,
    );

    final dio = Dio(options)
      ..interceptors.addAll([
        userAgentInterceptor,
        _logInterceptor(logger),
      ]);
    return dio;
  }
}

LogInterceptor _logInterceptor(Logger logger) {
  return LogInterceptor(
    requestBody: kDebugMode,
    requestHeader: kDebugMode,
    responseHeader: kDebugMode,
    logPrint: (o) => logger.d(o.toString(), tag: _Constants.tag),
  );
}

mixin _Constants {
  static const seconds_30 = 30000;
  static const seconds_45 = 45000;
  static const tag = "Http Client";
}
