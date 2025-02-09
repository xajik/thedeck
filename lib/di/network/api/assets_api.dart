/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:dio/dio.dart';

class AssetsApi {
  final Dio _client;

  AssetsApi(this._client);

  Future<AssetsResponse> download(String filePath, String? etag) async {
    final response = await _client.get(
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        headers: etag == null ? {} : {_Constants.ifNoMatchKey: etag},
      ),
    );
    return AssetsResponse(
      response.headers.value(_Constants.eTagKey),
      response.statusCode,
      response.data,
    );
  }
}

class AssetsResponse {
  final String? etag;
  final int? code;
  final List<int>? data;

  AssetsResponse(this.etag, this.code, this.data);

  isUpToDate() => code == _Constants.notModifiedCode;

  isSuccess() => code == _Constants.successCode;
}

mixin _Constants {
  static const ifNoMatchKey = "If-None-Match";
  static const eTagKey = "etag";
  static const notModifiedCode = 304;
  static const successCode = 200;
}
