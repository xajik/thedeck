/*
 *
 *  *
 *  * Created on 20 4 2023
 *
 */

import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

enum DevicePhysicalType {
  mobile,
  tablet,
  tv,
}

extension DevicePhysicalTypeExtension on DevicePhysicalType {
  double get maxDiagonalPixels {
    switch (this) {
      case DevicePhysicalType.mobile:
        return 1000;
      case DevicePhysicalType.tablet:
        return 2000;
      case DevicePhysicalType.tv:
        return double.infinity;
    }
  }
}

mixin DeviceTypeUtils {

  static os() => Platform.operatingSystem;
  static diagonal() => _getScreenDiagonalInPixels();
  static Size resolution() => ui.window.physicalSize;

  static DevicePhysicalType getDeviceType() {
    final diagonal = _getScreenDiagonalInPixels();
    if (diagonal < DevicePhysicalType.mobile.maxDiagonalPixels) {
      return DevicePhysicalType.mobile;
    } else if (diagonal < DevicePhysicalType.tablet.maxDiagonalPixels) {
      return DevicePhysicalType.tablet;
    } else {
      return DevicePhysicalType.tv;
    }
  }

  static double _getScreenDiagonalInPixels() {
    final Size screenSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double diagonal = sqrt(pow(width, 2) + pow(height, 2));
    return diagonal;
  }


}
