/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:the_deck/di/db/entity/assets_entity.dart';

import '../../../objectbox.g.dart';
import '../database.dart';

class AssetsEntityDao {
  final Database _database;

  late final _box = _database.box<AssetsEntity>();

  AssetsEntityDao(this._database);

  String? getEtag(String fileName) {
    final query = _box.query(AssetsEntity_.fileName.equals(fileName)).build();
    final result = query.findFirst();
    return result?.eTag;
  }

  void update(String fileName, String path, String? etag) {
    var asset =
        _box.query(AssetsEntity_.fileName.equals(fileName)).build().findFirst();
    if (asset != null) {
      asset.eTag = etag;
      asset.localPath = path;
    } else {
      asset = AssetsEntity.create(fileName, path, etag);
    }
    _box.put(asset);
  }
}
