/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:objectbox/objectbox.dart';

@Entity()
class AssetsEntity {
  @Id()
  int id = 0;
  String? fileName;
  String? localPath;
  String? url;
  String? eTag;
  @Property(type: PropertyType.date)
  DateTime updated;

  AssetsEntity({
    this.fileName,
    this.localPath,
    this.url,
    this.eTag,
    required this.updated,
  });

  factory AssetsEntity.create(String fileName, String localPath, String? etag) {
    return AssetsEntity(
      fileName: fileName,
      localPath: localPath,
      eTag: etag,
      updated: DateTime.now(),
    );
  }
}
