/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import 'dart:async';
import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../di/app_dependency.dart';
import 'error_dialog_localisation.dart';

class ErrorDialogWidget extends StatefulWidget {
  static const String route = "dialog/error";

  static const String typeKey = "typeKey";
  final ErrorDialogType type;

  ErrorDialogWidget({Key? key, required Map<String, dynamic>? arguments})
      : type = arguments?[ErrorDialogWidget.typeKey] ?? ErrorDialogType.generic,
        super(key: key);

  @override
  ErrorDialogWidgetState createState() => ErrorDialogWidgetState();
}

class ErrorDialogWidgetState extends State<ErrorDialogWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer(const Duration(seconds: _Constant.disposeTime), _onPopFunction);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ErrorDialogLocalisation localisation =
        ErrorDialogLocalisation(context.appLocalizations());
    _reportDialogShow();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_Constant.dialogCorner),
      ),
      title: Text(getTitle(localisation)),
      content: Text(getMessage(localisation)),
      actions: <Widget>[
        DpadContainer(
          onClick: _onPopFunction,
          onFocus: (bool isFocused) {},
          child: TextButton(
            onPressed: _onPopFunction,
            child: Text(localisation.ok.toUpperCase()),
          ),
        ),
      ],
    );
  }

  _onPopFunction() {
    _pop();
  }

  void _pop() {
    Provider.of<AppDependency>(context, listen: false).router.pop();
  }

  void _reportDialogShow() {
    Provider.of<AppDependency>(context, listen: false)
        .analytics
        .reportErrorDialog(widget.type.name);
  }

  String getTitle(ErrorDialogLocalisation loc) {
    switch (widget.type) {
      case ErrorDialogType.cameraPermission:
        return loc.camera;
      case ErrorDialogType.noInternet:
        return loc.wifi;
      case ErrorDialogType.failedToConnectToRoom:
      case ErrorDialogType.failedToCreateRoom:
        return loc.error;
      default:
        return loc.error;
    }
  }

  String getMessage(ErrorDialogLocalisation loc) {
    switch (widget.type) {
      case ErrorDialogType.cameraPermission:
        return loc.cameraPermission;
      case ErrorDialogType.noInternet:
        return loc.connectToWifi;
      case ErrorDialogType.failedToConnectToRoom:
        return loc.failedToConnectToRoom;
      case ErrorDialogType.failedToCreateRoom:
        return loc.failedToCreateRoom;
      default:
        return loc.genericError;
    }
  }
}

mixin _Constant {
  static const double dialogCorner = 16.0;
  static const disposeTime = 5;
}

enum ErrorDialogType {
  generic,
  cameraPermission,
  noInternet,
  failedToConnectToRoom,
  failedToCreateRoom,
}
