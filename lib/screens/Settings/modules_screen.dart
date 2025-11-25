import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/Settings/module_settings_model.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  bool isLoading = false;
  ModuleSettingsModel? moduleSettings;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() => isLoading = true);
    await moduleService.refreshModuleSettings();
    moduleSettings = moduleService.getModuleSettings();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        language.lblModules,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: () async {
              toast('Refreshing...');
              await init();
              toast('Refreshed');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: loadingWidgetMaker(),
            )
          : moduleSettings == null
              ? Center(child: Text('No data found', style: boldTextStyle()))
              : _buildModulesGrid(),
    );
  }

  // Build Grid View for Modules
  Widget _buildModulesGrid() {
    // List of modules and their statuses
    final modules = [
      {
        'name': 'Attendance',
        'enabled': moduleSettings!.isGeofenceModuleEnabled
      },
      {'name': 'Approvals', 'enabled': moduleSettings!.isApprovalModuleEnabled},
      {
        'name': 'Leave Requests',
        'enabled': moduleSettings!.isLeaveModuleEnabled
      },
      {
        'name': 'Expense Requests',
        'enabled': moduleSettings!.isExpenseModuleEnabled
      },
      {
        'name': 'Document Requests',
        'enabled': moduleSettings!.isDocumentModuleEnabled
      },
      {'name': 'Loan Requests', 'enabled': moduleSettings!.isLoanModuleEnabled},
      {'name': 'Task System', 'enabled': moduleSettings!.isTaskModuleEnabled},
      {
        'name': 'Client Visit',
        'enabled': moduleSettings!.isClientVisitModuleEnabled
      },
      {
        'name': 'Product & Ordering',
        'enabled': moduleSettings!.isProductModuleEnabled
      },
      {
        'name': 'Notice Board',
        'enabled': moduleSettings!.isNoticeModuleEnabled
      },
      {
        'name': 'Payment Collection',
        'enabled': moduleSettings!.isPaymentCollectionModuleEnabled
      },
      {
        'name': 'Dynamic Form',
        'enabled': moduleSettings!.isDynamicFormModuleEnabled
      },
      {'name': 'TeamChat', 'enabled': moduleSettings!.isChatModuleEnabled},
      {
        'name': 'Geo Fencing',
        'enabled': moduleSettings!.isGeofenceModuleEnabled
      },
      {
        'name': 'IP Based Attendance',
        'enabled': moduleSettings!.isIpBasedAttendanceModuleEnabled
      },
      {'name': 'UID Login', 'enabled': moduleSettings!.isUidLoginModuleEnabled},
      {
        'name': 'Offline Tracking',
        'enabled': moduleSettings!.isOfflineTrackingModuleEnabled
      },
      {
        'name': 'Payroll & Payslip',
        'enabled': moduleSettings!.isPayrollModuleEnabled
      },
      {
        'name': 'Sales Target',
        'enabled': moduleSettings!.isSalesTargetModuleEnabled
      },
      {
        'name': 'Digital ID',
        'enabled': moduleSettings!.isDigitalIdCardModuleEnabled
      },
      {'name': 'SOS', 'enabled': moduleSettings!.isSosModuleEnabled}
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: modules.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0, // Adjust height-to-width ratio
        ),
        itemBuilder: (context, index) {
          final module = modules[index];
          return _buildModuleCard(
            module['name'].toString(),
            bool.parse(
              module['enabled']!.toString(),
            ),
          );
        },
      ),
    );
  }

  // Build Individual Module Card
  Widget _buildModuleCard(String title, bool? isEnabled) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: context.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Static Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.widgets, // Replace with any desired static icon
                        size: 28,
                        color: appStore.appPrimaryColor,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                isEnabled == true ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isEnabled == true
                                ? language.lblEnabled
                                : language.lblDisabled,
                            style: primaryTextStyle(color: white, size: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Module Title
                  Expanded(
                    child: Text(
                      title,
                      style: boldTextStyle(size: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
