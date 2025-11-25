import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../Home/home_store.dart';
import 'Component/app_header_component.dart';
import 'Component/widgets_component.dart';

class HomeScreen extends StatefulWidget {
  final Function sidebarClick;
  const HomeScreen({super.key, required this.sidebarClick});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = HomeStore();
  bool isOffline = false;
  final _myScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.getOrderCount();
    globalAttendanceStore.refreshVisitsCount();
  }

  @override
  void dispose() {
    if (_myScrollController.hasClients) {
      _myScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);
    return Observer(
      builder: (_) => Scaffold(
          backgroundColor: appStore.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(),
                SingleChildScrollView(
                  controller: _myScrollController,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Column(
                      children: [
                        WidgetsComponent(
                          orderCountModel: _store.orderCountModel,
                          isOrderCountLoading: _store.isOrderCountLoading,
                        ),
                      ],
                    ).paddingOnly(left: 8, right: 8),
                  ),
                ).expand(),
              ],
            ),
          )),
    );
  }

  Widget greetingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text(
              'Good Morning',
              style: boldTextStyle(size: 24, weight: FontWeight.w500),
            ),
            7.height,
            Text(
              'Have a great day!',
              style: secondaryTextStyle(size: 16),
            ),
            16.height,
          ],
        ),
        Lottie.asset('assets/animations/sun.json', width: 50, height: 50),
      ],
    );
  }
}
