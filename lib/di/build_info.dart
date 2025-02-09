/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Sat Jan 07 2023
 */

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thedeck_common/the_deck_common.dart';

import 'device_type.dart';

class BuildInfo extends JsonEncodeable {
  String? appName;
  String? buildNumber;
  String? appVersion;
  String? appVersionByOS;
  String? systemName;
  String? systemVersion;
  String? model;
  String? brand;
  String? os;
  bool? isAndroidTv;

  bool get isTizen => model?.toLowerCase().contains(_Constants.tizen) ?? false;

  bool get isTv => isAndroidTv ?? false || isTizen;

  userAgent() =>
      '$appName/$appVersion ($os $systemName $systemVersion; ${_Constants.build} $buildNumber)';

  BuildInfo._();

  @override
  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'buildNumber': buildNumber,
      'appVersion': appVersion,
      'appVersionByOS': appVersionByOS,
      'systemName': systemName,
      'systemVersion': systemVersion,
      'model': model,
      'brand': brand,
      'os': os,
      'isAndroidTv': isAndroidTv,
      'isTizen': isTizen,
    };
  }
}

class BuildInformationProvider {
  static Future<BuildInfo> get buildInfo async {
    var buildInfo = BuildInfo._();
    final devicePlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    buildInfo.appVersion = packageInfo.version;
    buildInfo.buildNumber = packageInfo.buildNumber;
    buildInfo.appName = packageInfo.appName;
    buildInfo.os = DeviceTypeUtils.os();
    if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await devicePlugin.iosInfo;
      buildInfo.model = deviceInfo.model;
      buildInfo.systemName = _Constants.iOS;
      buildInfo.systemVersion = deviceInfo.systemVersion;
      buildInfo.brand = _Constants.apple;
      buildInfo.appVersionByOS =
          '${_Constants.app}-${_Constants.iOS}-${packageInfo.version}';
      buildInfo.isAndroidTv = false;
    } else {
      AndroidDeviceInfo deviceInfo = await devicePlugin.androidInfo;
      buildInfo.model = deviceInfo.model;
      buildInfo.systemName = _Constants.android;
      buildInfo.systemVersion = deviceInfo.version.release;
      buildInfo.brand = deviceInfo.brand;
      buildInfo.appVersionByOS =
          '${_Constants.app}-${_Constants.android}-${packageInfo.version}';
      buildInfo.isAndroidTv =
          deviceInfo.systemFeatures.contains(_Constants.androidLeanback);
    }
    return buildInfo;
  }
}

mixin _Constants {
  static const apple = 'apple';
  static const app = 'TheDeck';
  static const android = 'Android';
  static const iOS = 'iOS';
  static const build = 'Build';
  static const tizen = 'tizen';
  static const androidLeanback = 'android.software.leanback';
}
