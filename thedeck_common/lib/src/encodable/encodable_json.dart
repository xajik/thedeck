/*
 *
 *  *
 *  * Created on 14 2 2023
 *
 */

import 'dart:convert';

abstract class JsonEncodeable {

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());
}
