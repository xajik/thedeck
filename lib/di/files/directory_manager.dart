/*
 *
 *  *
 *  * Created on 9 5 2023
 *
 */

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryManager {
  Future<Directory> directory() => getTemporaryDirectory();

  Future<String> cachePath() async => (await directory()).path;

  Future<File> file(name) async {
    final path = await cachePath();
    return File('$path/$name');
  }
}
