/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../di/app_dependency.dart';

class MaterialDialogPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  bool _onPopPressed = false;

  MaterialDialogPageRoute({required this.builder, RouteSettings? settings})
      : super(
          settings: settings,
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              builder(context),
          opaque: false,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return GestureDetector(
      onTap: () {
        if (!_onPopPressed) {
          _onPopPressed = true;
          Provider.of<AppDependency>(context, listen: false).router.pop();
        }
      },
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}
