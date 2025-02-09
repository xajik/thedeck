/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../di/app_dependency.dart';
import '../style/color_utils.dart';

class TitleToolbarWidget extends StatelessWidget {
  final String title;
  final Function()? onBackPressed;

  final List<ToolbarMenuAction> actions;

  const TitleToolbarWidget({
    Key? key,
    required this.title,
    this.actions = const [],
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme();
    final router = Provider.of<AppDependency>(context, listen: false).router;
    onPressed() => onBackPressed == null ? router.pop() : onBackPressed!();
    return Row(
      children: [
        DpadContainer(
          onClick: onPressed,
          onFocus: (bool isFocused) {},
          child: IconButton(
            onPressed: onPressed,
            alignment: Alignment.center,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: _Constants.actionIconSize,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(_Constants.padding),
          constraints: const BoxConstraints.tightFor(
            height: _Constants.toolbarHeight,
          ),
          child: Text(
            title,
            style: textTheme.displayMedium,
          ),
        ),
        const Spacer(),
        ...actions.map((e) => DpadContainer(
              onClick: e.onPressed,
              onFocus: (bool isFocused) {},
              child: IconButton(
                onPressed: e.onPressed,
                icon: Icon(
                  e.icon,
                  size: _Constants.actionIconSize,
                ),
              ),
            )),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _Constants {
  static const toolbarHeight = 52.0;
  static const padding = 4.0;
  static const actionIconSize = 28.0;
}

class ToolbarMenuAction {
  final String? title;
  final IconData icon;
  final VoidCallback onPressed;

  const ToolbarMenuAction(
      {required this.icon, required this.onPressed, this.title});
}
