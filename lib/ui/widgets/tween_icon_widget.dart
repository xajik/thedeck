/*
 *
 *  *
 *  * Created on 25 5 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:the_deck/ui/style/color_utils.dart';

class AnimatedIconColor extends StatefulWidget {
  final IconData iconData;
  final double size;

  const AnimatedIconColor({super.key, required this.iconData, this.size = 24});

  @override
  _AnimatedIconColorState createState() => _AnimatedIconColorState();
}

class _AnimatedIconColorState extends State<AnimatedIconColor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: AppColors.red,
      end: AppColors.white,

    ).animate(_controller);

    _controller.repeat(
      reverse: true,
      period: Duration(seconds: 1)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Icon(
          widget.iconData,
          color: _colorAnimation.value,
          size: widget.size,
        );
      },
    );
  }
}
