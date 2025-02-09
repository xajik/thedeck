/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:flutter/material.dart';

import '../style/color_utils.dart';

class CustomElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final Icon? icon;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.icon,
    this.gradient = const LinearGradient(
      colors: [
        AppColors.purpleBright,
        AppColors.indigo,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  }) : super(key: key);

  const CustomElevatedButton.disabled({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.icon,
    this.gradient = const LinearGradient(
      colors: [
        AppColors.grey,
        AppColors.grey,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(20);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: onPressed != null ? gradient : null,
          color: onPressed != null ? null : AppColors.grey,
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: AppColors.blueDark,
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: _buildElevatedButton(borderRadius),
      ),
    );
  }

  ElevatedButton _buildElevatedButton(BorderRadiusGeometry borderRadius) {
    final icon = this.icon;
    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: _styleFrom(borderRadius),
        child: child,
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        style: _styleFrom(borderRadius),
        label: child,
      );
    }
  }

  ButtonStyle _styleFrom(BorderRadiusGeometry borderRadius) {
    return ElevatedButton.styleFrom(
      elevation: 4,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }
}
