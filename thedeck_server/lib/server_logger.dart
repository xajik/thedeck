/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */



import 'package:thedeck_common/the_deck_common.dart';

class ServerLogger extends CommonLogger {
  @override
  d(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    print("$tag [Debug] $message [${stack?.toString() ?? ""}] ");
  }

  @override
  e(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    print("$tag [Error] $message [${stack?.toString() ?? ""}] ");
  }

  @override
  i(String message, {String tag = _Constants.tag, StackTrace? stack}) {
    print("$tag [Info] $message [${stack?.toString() ?? ""}] ");
  }

}

mixin _Constants {
  static const tag = "Server";
}