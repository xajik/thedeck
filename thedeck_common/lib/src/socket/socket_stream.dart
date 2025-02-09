/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';


import '../common/common_logger.dart';
import 'api/api_constants.dart';

class SocketMessageStream {
  final CommonLogger log;
  final String tag;
  final _socketResponse = StreamController<Map<String, dynamic>>.broadcast();

  SocketMessageStream(this.log, [this.tag = _Constant.tag]);

  void Function(Map<String, dynamic>) get add => _socketResponse.sink.add;

  Stream<Map<String, dynamic>> get stream => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  StreamSubscription subscribe(void Function(Map<String, dynamic>) onData) {
    log.d("Registered stream listener for all events", tag: tag);
    return stream.listen(onData);
  }

  StreamSubscription subscribeWhere(
      String path, void Function(Map<String, dynamic>) onData) {
    log.d("Registered stream listener for path: $path", tag: tag);
    return stream
        .where((event) => event[ApiConstantsSocketPayload.path] == path)
        .listen(onData);
  }
}

mixin _Constant {
  static const tag = "SocketMessageStream";
}
