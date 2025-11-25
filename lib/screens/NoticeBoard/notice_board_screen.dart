import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/screens/NoticeBoard/notice_board_store.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  final _store = NoticeBoardStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (moduleService.isNoticeModuleEnabled()) {
      _store.getNoticeBoard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar:
          appBar(context, language.lblNoticeBoard, hideBack: true, actions: [
        IconButton(
          icon: Icon(Iconsax.refresh),
          onPressed: () {
            init();
          },
        ),
      ]),
      body: Observer(
        builder: (_) => !moduleService.isNoticeModuleEnabled()
            ? Center(
                child: Text(language.lblNoticeBoardIsNotEnabled),
              )
            : Observer(
                builder: (_) => _store.isLoading
                    ? loadingWidgetMaker()
                    : _store.notices.isEmpty
                        ? Center(
                            child: Text(language.lblNoNoticesFound),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MasonryGridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              itemCount: _store.notices.length,
                              itemBuilder: (context, index) {
                                bool isLight = index % 2 == 0;
                                return Card(
                                  color: isLight
                                      ? getRandomLightColor()
                                      : getRandomDarkColor(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _store.notices[index].title!,
                                          style: boldTextStyle(
                                              color: isLight
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        5.height,
                                        Text(
                                          _store.notices[index].contents!,
                                          style: secondaryTextStyle(
                                              color: isLight
                                                  ? Colors.grey.shade800
                                                  : Colors.white),
                                        ),
                                        10.height,
                                        Text(
                                          '${language.lblPostedOn}: ${_store.notices[index].createdAt!}',
                                          style: secondaryTextStyle(
                                              color: isLight
                                                  ? Colors.grey.shade800
                                                  : Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
      ),
    );
  }

  Color getRandomLightColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100;
  }

  Color getRandomDarkColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade700;
  }
}
