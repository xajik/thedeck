/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'dart:ui';

import 'package:the_deck/di/device_type.dart';
import 'package:thedeck_common/the_deck_common.dart';

class DeviceInformation extends JsonEncodeable {
  final DevicePhysicalType type;
  final String os;
  final double diagonal;
  final Size resolution;

  DeviceInformation(
    this.type,
    this.os,
    this.diagonal,
    this.resolution,
  );

  factory DeviceInformation.create() {
    return DeviceInformation(
      DeviceTypeUtils.getDeviceType(),
      DeviceTypeUtils.os(),
      DeviceTypeUtils.diagonal(),
      DeviceTypeUtils.resolution(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'os': os,
      'diagonal': diagonal,
      'resolutionWidth': resolution.width,
      'resolutionHeight': resolution.height,
    };
  }
}
