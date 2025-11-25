import 'package:open_core_hr/Utils/app_colors.dart';
import 'package:open_core_hr/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          boxShadow: defaultBoxShadow(),
          color: appStore.scaffoldBackground,
        ),
        child: Row(
          children: [
            navItem(
              Iconsax.home_1,
              pageIndex == 0,
              onTap: () => onTap(0),
            ),
            navItem(
              Iconsax.task_square,
              pageIndex == 1,
              onTap: () => onTap(1),
            ),
            const SizedBox(width: 80),
            navItem(
              Iconsax.activity,
              pageIndex == 2,
              onTap: () => onTap(2),
            ),
            navItem(
              Iconsax.message_2,
              pageIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? appStore.appColorPrimary : appStore.iconColor,
        ),
      ),
    );
  }
}

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}
