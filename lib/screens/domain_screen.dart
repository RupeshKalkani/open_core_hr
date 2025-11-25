import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Utils/app_widgets.dart';
import '../main.dart';
import '../models/DomainModel.dart';
import 'SettingUp/setting_up_screen.dart';

class DomainScreen extends StatefulWidget {
  const DomainScreen({super.key});

  @override
  State<DomainScreen> createState() => _DomainScreenState();
}

class _DomainScreenState extends State<DomainScreen> {
  List<TenantModel> tenants = [];
  bool isLoading = true;
  String? errorMessage;
  TenantModel? selectedDomain; // Selected domain

  @override
  void initState() {
    super.initState();
    clearSharedPref();
    fetchDomains();
  }

  Future<void> fetchDomains() async {
    try {
      setState(() {
        isLoading = true;
      });
      tenants = await apiService.getDomains();
    } catch (e) {
      errorMessage = "Failed to load domains. Please try again later.";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblSelectOrganization, hideBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: loadingWidgetMaker())
            : tenants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        16.height,
                        Text(
                          errorMessage ?? language.lblNoOrganizationFound,
                          style: boldTextStyle(size: 16),
                          textAlign: TextAlign.center,
                        ),
                        16.height,
                        ElevatedButton(
                          onPressed: fetchDomains,
                          child: Text(language.lblRetry),
                        )
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        language.lblChooseYourOrganizationFromTheListBelow,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      20.height,
                      DropdownButtonFormField<TenantModel>(
                        decoration: newEditTextDecoration(
                          Icons.domain,
                          language.lblOrganizations,
                        ),
                        items: tenants.map((e) {
                          return DropdownMenuItem<TenantModel>(
                            value: e,
                            child: Text(
                              e.tenantName!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDomain = value;
                            setValue('baseurl', '${selectedDomain!.domain}/');
                            setValue(
                                'organization', selectedDomain!.tenantName);
                            appStore.centralDomainURL =
                                selectedDomain!.tenantName;
                          });
                        },
                        isExpanded: true,
                        hint: Text(language.lblSelectAOrganization),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedDomain == null) {
            toast(language.lblPleaseSelectAOrganization);
            return;
          }
          SettingUpScreen().launch(context, isNewTask: true);
        },
        icon: const Icon(Icons.arrow_forward),
        label: Text(language.lblProceed),
        backgroundColor: appStore.appColorPrimary,
      ),
    );
  }
}
