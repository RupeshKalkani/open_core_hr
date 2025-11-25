import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Widgets/home_attendance_loading_widget.dart';
import '../../../main.dart';
import 'attendance_type_widget.dart';
import 'in_out_component.dart';

class AttendanceComponent extends StatefulWidget {
  const AttendanceComponent({super.key});

  @override
  State<AttendanceComponent> createState() => _AttendanceComponentState();
}

class _AttendanceComponentState extends State<AttendanceComponent> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        children: [
          appStore.isStatusCheckLoading
              ? CustomLoadingWidget()
              : globalAttendanceStore.isNew ||
                      globalAttendanceStore.isCheckedIn ||
                      globalAttendanceStore.isCheckedOut
                  ? Column(
                      children: [
                        AttendanceTypeWidget(
                          type: globalAttendanceStore.attendanceType,
                        ).paddingOnly(
                          bottom: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      globalAttendanceStore.isCheckedIn
                                          ? 10.height
                                          : Container(),
                                      const InOutComponent().paddingAll(8.0),
                                      10.height,
                                    ],
                                  )),
                            ).expand(),
                          ],
                        ),
                      ],
                    )
                  : Container()
        ],
      ),
    );
  }
}
