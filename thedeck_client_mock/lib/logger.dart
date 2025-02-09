/*
 *
 *  *
 *  * Created on 8 8 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class Logger extends CommonLogger {
  @override
  d(String message, {String tag = _Constant.TAG, StackTrace? stack}) {
    print("$tag: $message");
  }

  @override
  e(String message, {String tag = _Constant.TAG, StackTrace? stack}) {
    print("$tag: $message");
  }

  @override
  i(String message, {String tag = _Constant.TAG, StackTrace? stack}) {
    print("$tag: $message");
  }
}

mixin _Constant {
  static const String TAG = "Logger";
}
