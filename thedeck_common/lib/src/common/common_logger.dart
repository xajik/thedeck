/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

abstract class CommonLogger {
  d(String message, {String tag, StackTrace? stack});

  e(String message, {String tag, StackTrace? stack});

  i(String message, {String tag, StackTrace? stack});
}
