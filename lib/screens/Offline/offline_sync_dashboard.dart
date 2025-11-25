import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/main.dart';

import '../../service/offline_tracking_sync_service.dart';

class OfflineSyncDashboard extends StatefulWidget {
  @override
  _OfflineSyncDashboardState createState() => _OfflineSyncDashboardState();
}

class _OfflineSyncDashboardState extends State<OfflineSyncDashboard> {
  int deviceStatusCount = 0;
  int activityStatusCount = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  /// Load the counts of unsynced data
  void loadStats() {
    setState(() {
      deviceStatusCount =
          OfflineTrackingSyncService.getAllDeviceStatusData().length;
      activityStatusCount =
          OfflineTrackingSyncService.getAllActivityStatusData().length;
    });
  }

  /// Trigger sync and reload stats
  Future<void> triggerSync() async {
    await OfflineTrackingSyncService.periodicSync();
    loadStats();
  }

  ///Delete all unsynced data
  Future<void> deleteData() async {
    await OfflineTrackingSyncService.deleteAll();
    loadStats();
  }

  /// View details of a specific data type
  void viewData(String type) {
    final data = type == 'DeviceStatus'
        ? OfflineTrackingSyncService.getAllDeviceStatusData()
        : OfflineTrackingSyncService.getAllActivityStatusData();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type Details',
                style: boldTextStyle(size: 18),
              ),
              SizedBox(height: 10),
              Expanded(
                child: data.isEmpty
                    ? Center(
                        child: Text(
                          'No unsynced $type data available.',
                          style: primaryTextStyle(size: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          // Validate and display data
                          if (item is Map<String, dynamic>) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  'Record ${index + 1}',
                                  style: boldTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  item,
                                  style: primaryTextStyle(size: 12),
                                ),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                'Invalid Data',
                                style: boldTextStyle(size: 14),
                              ),
                              subtitle: Text(
                                item.toString(),
                                style: primaryTextStyle(size: 12),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(
        context,
        'Offline Sync Dashboard',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              loadStats();
              toast('Data refreshed!');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unsynced Data Count:',
              style: boldTextStyle(size: 18),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDataCard(
                    title: 'Device Status',
                    count: deviceStatusCount,
                    onViewTap: () {
                      //viewData('DeviceStatus');
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDataCard(
                    title: 'Activity Status',
                    count: activityStatusCount,
                    onViewTap: () {
                      //viewData('ActivityStatus');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            /*     Center(
              child: button(
                'Sync Now',
                onTap: () async {
                  await triggerSync();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sync triggered successfully!')),
                  );
                },
              ),
            ),
             20.height,
            Center(
              child: button(
                'Delete',
                onTap: () async {
                  await deleteData();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted successfully!')),
                  );
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  /// Widget for a Data Card
  Widget _buildDataCard({
    required String title,
    required int count,
    required VoidCallback onViewTap,
  }) {
    return GestureDetector(
      onTap: onViewTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.appColorPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: boldTextStyle(size: 16, color: white),
            ),
            SizedBox(height: 8),
            Text(
              'Count: $count',
              style: primaryTextStyle(size: 14, color: white),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
