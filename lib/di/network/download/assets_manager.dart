/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:the_deck/di/files/directory_manager.dart';
import 'package:the_deck/di/logger.dart';

import '../../db/dao/assets_dao.dart';
import '../api/assets_api.dart';

class AssetsFileManager {
  final AssetsApi _assetsApi;
  final AssetsEntityDao _assetsEntityDao;
  final DirectoryManager _directoryManager;
  final Logger _logger;

  AssetsFileManager(this._assetsApi,
      this._assetsEntityDao,
      this._directoryManager,
      this._logger,);

  Future<bool> downloadCdnAll(String folder, List<String> fileName) async {
    try {
      final futures = <Future<String?>>[];
      for (final name in fileName) {
        futures.add(downloadCdn(folder, name));
      }
      final paths = await Future.wait(futures);
      _logger.d("Downloaded ${paths.length} files", tag: _Constant.tag);
      return paths.every((element) => element != null);
    } catch (e) {
      _logger.e(e.toString(), tag: _Constant.tag);
    }
    return false;
  }

  Future<String?> downloadCdn(String folder, String fileName) async {
    try {
      final file = await _directoryManager.file(folder + fileName);
      String? etag;
      if (await file.exists()) {
        etag = _assetsEntityDao.getEtag(fileName);
      } else {}
      final response = await _assetsApi.download(fileName, etag);
      if (response.isUpToDate()) {
        _logger.d("File $fileName is up to date", tag: _Constant.tag);
        return file.path;
      } else if (response.isSuccess()) {
        final data = response.data;
        if (data != null && data.isNotEmpty) {
          await file.writeAsBytes(data);
          _assetsEntityDao.update(fileName, file.path, response.etag);
          return file.path;
        } else {
          _logger.e("Failed to download $fileName: ${response.code}",
              tag: _Constant.tag);
        }
      } else {
        _logger.e("Failed to download $fileName: ${response.code}",
            tag: _Constant.tag);
      }
      if (await file.exists() && await file.length() > 0) {
        return file.path;
      }
    } catch (e) {
      _logger.e(e.toString(), tag: _Constant.tag);
    }
    return null;
  }
}

mixin _Constant {
  static const tag = "AssetsManager";
}
