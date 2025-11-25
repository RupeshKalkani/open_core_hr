import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';

import '../main.dart';

AppButton button(String text,
    {Function? onTap, Color? color, Color textColor = white}) {
  return AppButton(
      text: text,
      color: color ?? appStore.appPrimaryColor,
      textColor: textColor,
      shapeBorder: buildButtonCorner(),
      width: 120,
      onTap: onTap);
}

AppButton iconButton(String text, IconData icon,
    {Function? onTap, Color? color, Color textColor = white}) {
  return AppButton(
    color: color ?? appStore.appPrimaryColor,
    textColor: textColor,
    shapeBorder: buildButtonCorner(),
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: textColor,
        ),
        5.width,
        Text(
          text,
          style: boldTextStyle(
            color: textColor,
          ),
        ),
      ],
    ),
  );
}
