/*
 * Copyright (c) 2023 thedeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Mon Jan 09 2023
 */

import 'package:objectbox/objectbox.dart';

@Entity()
class UserEntity {
  @Id()
  int id = 0;
  String? name;
  String? surname;
  String nickName = "";
  String? email;
  String? userRemoteKey;
  String userLocalKey = "";
  String? image;
  int score = 0;
  @Property(type: PropertyType.date)
  DateTime? updated;

  String getKey() => userRemoteKey ?? userLocalKey;
}
