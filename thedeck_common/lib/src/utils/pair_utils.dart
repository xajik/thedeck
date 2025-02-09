/*
 *
 *  *
 *  * Created on 31 1 2023
 *
 */


import '../encodable/encodable_json.dart';

class Pair<T, Y> extends JsonEncodeable {
  final T first;
  final Y second;

  Pair(this.first, this.second);

  static Pair<T, Y> of<T, Y>(T first, Y second) {
    return Pair(first, second);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'first': first,
      'second': second,
    };
  }

  factory Pair.fromMap(Map<String, dynamic> json) {
    return Pair(
      json["first"],
      json["second"],
    );
  }

}
