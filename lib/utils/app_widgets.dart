import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';
import '../screens/Cart/cart_screen.dart';
import '../screens/navigation_screen.dart';
import 'app_colors.dart';
import 'app_constants.dart';

Widget buildShimmer(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[400]!.withOpacity(0.3),
      highlightColor: Colors.grey[100]!.withOpacity(0.5),
      child: Card(
        shape: buildRoundedCorner(),
        color: Colors.white,
      ),
    ),
  );
}

RoundedRectangleBorder buildRoundedCorner({double? radius}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 10));
}

RoundedRectangleBorder buildCardCorner({double? radius}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 16));
}

RoundedRectangleBorder buildButtonCorner({double? radius}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 10));
}

RoundedRectangleBorder bottomSheetShape() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  );
}

// EditText rounded Style
Padding editTextStyle(var hintText,
    {isPassword = true, TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
    child: TextFormField(
      style: const TextStyle(
          fontSize: fontSizeLargeMedium, fontFamily: fontRegular),
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        hintText: hintText,
        filled: true,
        fillColor: appStore.isDarkModeOn ? cardDarkColor : white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:
                const BorderSide(color: editTextBackground, width: 0.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: editTextBackground, width: 0.0),
        ),
      ),
    ),
  );
}

// Login/SignUp HeadingElement
Text formHeading(var label) {
  return Text(label,
      style: TextStyle(
          color: appStore.textPrimaryColor, fontSize: 30, fontFamily: fontBold),
      textAlign: TextAlign.center);
}

Text formSubHeadingForm(var label) {
  return Text(label,
      style: TextStyle(
          color: appStore.textSecondaryColor,
          fontSize: 20,
          fontFamily: fontBold),
      textAlign: TextAlign.center);
}

class CustomTheme extends StatelessWidget {
  final Widget? child;

  const CustomTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: appStore.appColorPrimary)
                  .copyWith(background: context.scaffoldBackgroundColor),
            )
          : ThemeData.light(),
      child: child!,
    );
  }
}

Widget text(
  String? text, {
  var fontSize = fontSizeLargeMedium,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor ?? appStore.textSecondaryColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

Widget shadowButton(String name) {
  return MaterialButton(
    height: 60,
    minWidth: double.infinity,
    textColor: white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    color: appStore.appColorPrimary,
    onPressed: () => {toast("Hi 2")},
    child: text(name,
        fontSize: fontSizeLargeMedium,
        textColor: white,
        fontFamily: fontMedium),
  );
}

AppBar appBar(BuildContext context, String title,
    {Function? backPress,
    Color? appBarBgColor,
    Color? textColor,
    bool hideBack = false,
    List<Widget>? actions}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: appBarBgColor ?? Colors.transparent,
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(color: textColor),
    ),
    leading: hideBack
        ? null
        : Container(
            margin: const EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Icon(Icons.arrow_back, color: appStore.textPrimaryColor),
          ).onTap(backPress ?? () => finish(context)),
    actions: actions,
  );
}

AppBar cartAppBar(BuildContext context, String title,
    {Function? backPress,
    Color? appBarBgColor,
    Color? textColor,
    bool hideBack = false,
    List<Widget>? actions}) {
  return AppBar(
    backgroundColor: appBarBgColor ?? Colors.transparent,
    elevation: 0,
    title: Text(
      title,
      style: boldTextStyle(
          color: textColor ?? appStore.textPrimaryColor, size: 19),
    ),
    leading: hideBack
        ? null
        : Container(
            margin: const EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Icon(Icons.arrow_back, color: appStore.textPrimaryColor),
          ).onTap(
            backPress ?? () => NavigationScreen().launch(context),
          ),
    actions: [
      badges.Badge(
        badgeContent: Observer(
          builder: (_) => Text(
            appStore.cartCount.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        position: badges.BadgePosition.topEnd(top: 0, end: 0),
        child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          },
          icon: Icon(
            Icons.shopping_cart,
            color: appStore.iconColor,
          ),
        ),
      ),
      const SizedBox(
        width: 10.0,
      ),
    ],
  );
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget divider() {
  return const Divider(
    height: 0.7,
    color: Colors.grey,
  );
}

Widget weekWidget(String text, Color bgColor) {
  return Container(
    width: 32,
    decoration: boxDecorationWithRoundedCorners(backgroundColor: bgColor),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Text(
          text,
          style: primaryTextStyle(color: white, size: 12),
        ),
      ),
    ),
  ).paddingRight(4);
}

Widget itemRowWidget(String title, value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: primaryTextStyle(color: white),
      ),
      10.width,
      Text(
        value,
        style: primaryTextStyle(color: white),
      ),
    ],
  );
}

Widget itemRowTWidget(String title, value, Color textColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: primaryTextStyle(color: textColor),
      ),
      10.width,
      Text(
        value,
        style: primaryTextStyle(color: textColor),
      ),
    ],
  );
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: appStore.appPrimaryColor,
        ),
      ),
    ),
  );
}

Widget settingItem(String name, double width, {IconData? icon, var pad = 8.0}) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.all(pad),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 18),
            width: width / 7.5,
            height: width / 7.5,
            padding: const EdgeInsets.all(7),
            decoration: icon != null
                ? boxDecoration(
                    radius: 4,
                    bgColor: appStore.scaffoldBackground,
                  )
                : null,
            child: icon != null ? Icon(icon) : const SizedBox(),
          ),
          text(name,
              textColor: appStore.textPrimaryColor,
              fontFamily: fontMedium,
              fontSize: fontSizeLargeMedium)
        ],
      ),
    ),
  );
}

InputDecoration editTextDecoration(IconData icon, String title,
    {String? errorText}) {
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
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorText: errorText,
    labelText: title,
    labelStyle: primaryTextStyle(),
  );
}

InputDecoration newEditTextDecoration(IconData icon, String title,
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
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor ?? appStore.appColorPrimary)),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.red),
    ),
    fillColor: bgColor ?? appStore.appColorPrimary.withOpacity(0.04),
    hintText: hint,
    errorText: errorText,
    labelText: title,
    prefixIcon: Icon(icon, color: appStore.appColorPrimary),
    hintStyle: secondaryTextStyle(),
    filled: true,
  );
}

InputDecoration newEditTextNoIconDecoration(String title,
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

class FooterSignature extends StatelessWidget {
  final String companyName;
  final Color textColor;
  final Color iconColor;

  const FooterSignature({
    super.key,
    this.companyName = "WUV.inc",
    this.textColor = Colors.black87,
    this.iconColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Code with ",
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
                Icon(Icons.favorite, size: 16, color: iconColor),
                Text(
                  " by $companyName",
                  style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            5.height,
            Text(
              '$mainAppName ${getStringAsync(appVersionPref)}',
              style: secondaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget profileImageWidget({double size = 20, double indSize = 15}) {
/*  final Map<String, Color> statusColors = {
    'online': Colors.green,
    'offline': Colors.grey,
    'busy': Colors.red,
    'away': Colors.orange,
    'on_call': Colors.blueAccent,
    'do_not_disturb': Colors.purple,
    'on_leave': Colors.teal,
    'on_meeting': Colors.cyan,
    'unknown': Colors.grey,
  };*/

  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: appStore.appPrimaryColor.withOpacity(0.5),
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: size + 3,
          backgroundColor: appStore.appPrimaryColor.withOpacity(0.2),
          backgroundImage: sharedHelper.hasProfileImage()
              ? NetworkImage(sharedHelper.getProfileImage())
              : null,
          child: !sharedHelper.hasProfileImage()
              ? Text(
                  sharedHelper.getUserInitials(),
                  style: boldTextStyle(
                    size: int.parse(size.toStringAsFixed(0)),
                  ),
                )
              : null,
        ),
      ),
      /* Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: indSize,
          height: indSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: statusColors[appStore.currentUserStatus] ?? Colors.grey,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
          ),
        ),
      ),*/
    ],
  );
}

Widget userProfileWidget(String name,
    {double size = 20,
    double indSize = 15,
    String? imageUrl,
    String status = 'unknown',
    bool hideStatus = false}) {
  final Map<String, Color> statusColors = {
    'online': Colors.green,
    'offline': Colors.grey,
    'busy': Colors.red,
    'away': Colors.orange,
    'on_call': Colors.blueAccent,
    'do_not_disturb': Colors.purple,
    'on_leave': Colors.teal,
    'on_meeting': Colors.cyan,
    'unknown': Colors.grey,
  };

  String initials = name.split(' ').map((e) => e[0]).join();

  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: appStore.appPrimaryColor.withOpacity(0.5),
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: size + 3,
          backgroundColor: appStore.appPrimaryColor.withOpacity(0.2),
          backgroundImage: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : null,
          child: imageUrl == null
              ? Text(
                  initials,
                  style: boldTextStyle(
                    size: int.parse(size.toStringAsFixed(0)),
                  ),
                )
              : null,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: hideStatus
            ? Container()
            : Container(
                width: indSize,
                height: indSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColors[status] ?? Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
      ),
    ],
  );
}

Widget noDataWidget({double height = 200, String? message = 'No data!'}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/animations/no-data.json', height: height),
        Text(message!, style: boldTextStyle(size: 16)),
      ],
    ),
  );
}

BoxDecoration cardDecoration({Color? color, List<BoxShadow>? boxShadow}) {
  return BoxDecoration(
    color: color ?? appStore.appColorPrimary.withOpacity(0.11),
    borderRadius: BorderRadius.circular(16),
    boxShadow: boxShadow,
  );
}

// Helper to build action buttons
Widget buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        6.width,
        Text(
          label,
          style: primaryTextStyle(color: color, size: 12),
        ),
      ],
    ).paddingSymmetric(vertical: 6),
  );
}

Widget statusWidget(String status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _getStatusColor(status),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      status,
      style: boldTextStyle(
        size: 12,
        color: white,
      ),
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'processing':
      return Colors.blueAccent;
    case 'cancelled':
      return Colors.red;
    case 'completed':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Widget buildUserHeader(String name,
    {String? status,
    String? imageUrl,
    String? designation,
    bool hideStatus = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      userProfileWidget(name,
          size: 15,
          indSize: 15,
          imageUrl: imageUrl,
          status: status ?? 'unknown',
          hideStatus: hideStatus),
      8.width,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: boldTextStyle(size: 16),
          ),
          if (designation != null)
            Text(
              'Designation',
              style: secondaryTextStyle(size: 12),
            ),
        ],
      ),
    ],
  );
}
