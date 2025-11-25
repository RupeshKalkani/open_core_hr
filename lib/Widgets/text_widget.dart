import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Utils/app_colors.dart';
import '../main.dart';

InputDecoration textInputDecoration(String label, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: appStore.iconColor,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(color: appStore.iconColor!),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(color: appStore.iconColor!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(width: 1, color: appStore.iconColor!),
    ),
    labelText: label,
    labelStyle: primaryTextStyle(),
  );
}

InputDecoration textInputDecorationNoIcon(String label,
    {String? hintText = null}) {
  return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: appStore.iconColor!),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: appStore.iconColor!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(width: 1, color: appStore.iconColor!),
      ),
      labelText: label,
      labelStyle: primaryTextStyle(),
      hintText: hintText);
}

InputDecoration newEditTextDecorationNoIcon(String title,
    {String? hint,
    Color? bgColor,
    Color? borderColor,
    EdgeInsets? padding,
    String? errorText}) {
  return InputDecoration(
    contentPadding:
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    counter: const Offstage(),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor ?? appStore.appColorPrimary)),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.red),
    ),
    fillColor: bgColor ?? appStore.appColorPrimary.withOpacity(0.04),
    hintText: hint,
    errorText: errorText,
    labelText: title,
    hintStyle: secondaryTextStyle(),
    filled: true,
  );
}
