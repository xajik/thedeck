/*
 *
 *  *
 *  * Created on 6 5 2023
 *
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../di/app_dependency.dart';
import '../style/color_utils.dart';

class FullScreenImageWidget extends StatelessWidget {
  static const route = 'widget/fullScreenImage';
  static const imageUrlKey = 'imageUrl';
  static const fallbackAssetKey = 'fallbackAsset';
  final String imageUrl;
  final String fallbackAsset;

  FullScreenImageWidget.fromMap({
    Key? key,
    required Map<String, dynamic> args,
  })  : imageUrl = args["imageUrl"],
        fallbackAsset = args["fallbackAsset"],
        super(key: key);

  const FullScreenImageWidget({
    Key? key,
    required this.imageUrl,
    required this.fallbackAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = Image.asset(fallbackAsset);
    return Hero(
      tag: imageUrl,
      child: Container(
        color: AppColors.transparent,
        alignment: Alignment.center,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.vertical,
          onDismissed: (_) {
            _pop(context);
          },
          child: CachedNetworkImage(
            color: AppColors.yellow,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: AppColors.transparent),
              imageProvider: imageProvider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
            ),
            fit: BoxFit.contain,
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
          ),
        ),
      ),
    );
  }

  void _pop(BuildContext context) {
    Provider.of<AppDependency>(context, listen: false).router.pop();
  }
}
