/*
 *
 *  *
 *  * Created on 9 5 2023
 *
 */

import 'dart:io';
import 'package:thedeck_common/the_deck_common.dart';

import '../logger.dart';
import 'directory_manager.dart';

class GameLogFileManager {
  final DirectoryManager _directoryManager;
  final Logger _logger;

  GameLogFileManager(
    this._directoryManager,
    this._logger,
  );

  Future<String> saveLog(String roomId, JsonEncodeable encodeable) async {
    final file = await _logFile(roomId);
    await file.create(recursive: true);
    await file.writeAsString(encodeable.toJson());
    final path = file.path;
    _logger.d('Created game log for $roomId at $path', tag: _Constant.tag);
    return path;
  }

  Future<String?> readLog(String roomId) async {
    final file = await _logFile(roomId);
    try {
      _logger.d('Read log file path: ${file.path}', tag: _Constant.tag);
      return await file.readAsString();
    } catch (e) {
      _logger.e('Failed to load log: $e', tag: _Constant.tag);
      return null;
    }
  }

  Future<File> _logFile(String roomId) async {
    final path = "${_Constant.logFolder}/$roomId${_Constant.jsonExtension}";
    _logger.d('Log file path: $path', tag: _Constant.tag);
    return _directoryManager.file(path);
  }

  Future<List<File>> getLogFiles() async {
    final dir = await _logDirectory();
    final files = await dir.list().toList();
    return files.whereType<File>().toList();
  }

  Future<void> deleteLog(String roomId) async {
    final file = await _logFile(roomId);
    _logger.d('Delete log file path: ${file.path}', tag: _Constant.tag);
    await file.delete();
  }

  Future<Directory> _logDirectory() async {
    final dir = await _directoryManager.directory();
    final path = "${dir.path}/${_Constant.logFolder}";
    _logger.d('Log file directory: $path', tag: _Constant.tag);
    return Directory(path).create(recursive: true);
  }
}

mixin _Constant {
  static const tag = "GameLogFileManager";
  static const jsonExtension = ".json";
  static const logFolder = "log";
}
