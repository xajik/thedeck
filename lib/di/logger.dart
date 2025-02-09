/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:thedeck_common/the_deck_common.dart';

class Logger extends CommonLogger {

  @override
  d(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag,
        time: DateTime.now(),
        stackTrace: stack,
        level: _Constants.debug,
      );
    }
  }

  @override
  e(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    if (kDebugMode) {
      developer.log(
        message,
        stackTrace: stack,
        time: DateTime.now(),
        name: tag,
        level: _Constants.error,
      );
    }
  }

  @override
  i(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    developer.log(
      message,
      stackTrace: stack,
      time: DateTime.now(),
      name: tag,
      level: _Constants.information,
    );
  }
}

mixin _Constants {
  static const tag = "Logger";
  static const error = 10;
  static const debug = 7;
  static const information = 1;
}
