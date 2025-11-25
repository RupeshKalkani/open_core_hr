import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Utils/app_colors.dart';

class ViewImageScreen extends StatelessWidget {
  final String imgUrl;
  const ViewImageScreen({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblImage),
      body: Center(
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            errorWidget: (_, __, ___) => Column(
              children: [
                const Icon(
                  Iconsax.image,
                  size: 100,
                  color: appColorPrimary,
                ),
                Text(
                  language.lblImageNotAvailable,
                  style: primaryTextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
