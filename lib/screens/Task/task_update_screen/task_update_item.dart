import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Task/task_update_screen/view_image_screen.dart';
import 'package:open_core_hr/screens/Task/task_update_screen/view_pdf_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../models/Task/task_update_model.dart';
import '../../../service/map_helper.dart';

class TaskUpdateItem extends StatefulWidget {
  final TaskUpdateModel update;
  const TaskUpdateItem({super.key, required this.update});

  @override
  State<TaskUpdateItem> createState() => _TaskUpdateItemState();
}

class _TaskUpdateItemState extends State<TaskUpdateItem> {
  String youText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    String activity = widget.update.taskUpdateType!.toLowerCase();
    if (activity == 'comment') {
      youText = language.lblSharedComments;
    } else if (activity == 'start') {
      youText = language.lblStartedTheTask;
    } else if (activity == 'hold') {
      youText = language.lblPausedTheTask;
    } else if (activity == 'unhold') {
      youText = language.lblResumedTheTask;
    } else if (activity == 'resume') {
      youText = language.lblResumedTheTask;
    } else if (activity == 'complete') {
      youText = language.lblCompletedTheTask;
    } else if (activity == 'image') {
      youText = language.lblSharedAnImage;
    } else if (activity == 'document') {
      youText = language.lblSharedADocument;
    } else if (activity == 'location') {
      youText = language.lblSharedALocation;
    } else {
      youText = language.lblShared;
    }

    if (widget.update.isFromAdmin!) {
      youText = '${language.lblAdmin} $youText';
    } else {
      youText = '${language.lblYou} $youText';
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.update.taskUpdateType!.toLowerCase() == 'start' ||
            widget.update.taskUpdateType!.toLowerCase() == 'hold' ||
            widget.update.taskUpdateType!.toLowerCase() == 'unhold'
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Text(youText).paddingAll(8),
                ),
                Text(
                  widget.update.createdAt!,
                  style: primaryTextStyle(),
                ).paddingAll(8),
              ],
            ),
          )
        : Card(
            color: widget.update.isFromAdmin!
                ? appStore.appColorPrimary
                : appStore.scaffoldBackground,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.task_square,
                            size: 16,
                          ),
                          5.width,
                          Text(
                            youText,
                            style: boldTextStyle(),
                          ),
                        ],
                      ),
                      10.height,
                    ],
                  ),
                  10.height,
                  if (widget.update.taskUpdateType!.toLowerCase() == 'comment')
                    Text(
                      widget.update.comment!,
                      style: primaryTextStyle(),
                    ),
                  if (widget.update.taskUpdateType!.toLowerCase() == 'image')
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CachedNetworkImage(
                        imageUrl: widget.update.fileUrl!,
                        height: 200,
                        errorWidget: (_, __, ___) => Column(
                          children: [
                            const Icon(
                              Iconsax.image,
                              size: 100,
                              color: Color.fromARGB(255, 23, 11, 156),
                            ),
                            Text(
                              language.lblImageNotAvailable,
                              style: primaryTextStyle(),
                            ),
                          ],
                        ),
                      ).cornerRadiusWithClipRRect(10).onTap(
                        () {
                          ViewImageScreen(imgUrl: widget.update.fileUrl!)
                              .launch(context);
                        },
                      ),
                    ),
                  /*Image.network(
                      widget.update.fileUrl!,
                      height: 200,
                    ).cornerRadiusWithClipRRect(10).onTap(
                      () {
                        ViewImageScreen(imgUrl: widget.update.fileUrl!)
                            .launch(context);
                      },
                    ),*/
                  if (widget.update.taskUpdateType!.toLowerCase() == 'location')
                    ElevatedButton(
                      onPressed: () {
                        MapHelper helper = MapHelper();
                        helper.launchMap(context, widget.update.latitude!,
                            widget.update.longitude!, language.lblLocationInfo);
                      },
                      child: Text(
                        language.lblViewLocationInMaps,
                        style: primaryTextStyle(),
                      ),
                    ),
                  if (widget.update.taskUpdateType!.toLowerCase() == 'document')
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ViewPdfScreen(
                              title: language.lblDocument,
                              url: widget.update.fileUrl!,
                            ).launch(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.document),
                              5.width,
                              Text(
                                language.lblViewDocument,
                                style: primaryTextStyle(),
                              ),
                            ],
                          ),
                        ),
                        10.width,
                        ElevatedButton(
                          onPressed: () {
                            launchInBrowser(Uri.parse(widget.update.fileUrl!));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.document_download),
                              5.width,
                              Text(
                                language.lblDownloadDocument,
                                style: primaryTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 16,
                            color: widget.update.isFromAdmin!
                                ? white
                                : appStore.textPrimaryColor,
                          ),
                          5.width,
                          Text(
                            widget.update.createdAt!,
                            style: primaryTextStyle(
                                color: widget.update.isFromAdmin!
                                    ? white
                                    : appStore.textPrimaryColor),
                          ),
                        ],
                      ).paddingAll(5),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      toast(language.lblUnableToDownloadTheFile);
    }
  }
}
