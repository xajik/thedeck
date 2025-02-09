/*
 *
 *  *
 *  * Created on 22 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:the_deck/ui/style/dimmension_utils.dart';

import 'color_utils.dart';

BoxDecoration gradientRoundedBoxDecoration() {
  return BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.indigo,
        AppColors.purpleBright,
      ],
    ),
    borderRadius: BorderRadius.circular(Dim.dialogCornerRadius),
  );
}
