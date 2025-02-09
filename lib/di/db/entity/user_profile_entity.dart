/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:objectbox/objectbox.dart';
import 'package:the_deck/di/db/entity/user_entity.dart';
import 'package:thedeck_common/the_deck_common.dart';

@Entity()
class UserProfileEntity {
  @Id()
  int id = 0;
  @Unique()
  String userId = "";
  String nickName = "";
  String? email;
  String? image;
  int score = 0;
  @Property(type: PropertyType.date)
  DateTime? updated;

  UserProfileEntity({
    required this.userId,
    required this.nickName,
    required this.score,
    this.email,
    this.image,
    this.updated,
  });

  factory UserProfileEntity.fromUserEntity(UserEntity user) {
    return UserProfileEntity(
      userId: user.getKey(),
      nickName: user.nickName,
      email: user.email,
      image: user.image,
      score: user.score,
      updated: user.updated,
    );
  }

  factory UserProfileEntity.fromGameParticipant(GameParticipant participant,
      {int? id}) {
    var entity = UserProfileEntity(
      userId: participant.userId,
      nickName: participant.profile.nickname,
      image: participant.profile.image,
      score: participant.profile.score,
    );
    if (id != null) {
      entity.id = id;
    }
    return entity;
  }
}
