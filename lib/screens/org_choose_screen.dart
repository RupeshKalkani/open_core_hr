import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart'; // For setValue, toast, height, etc.
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/models/DomainModel.dart'; // Assuming TenantModel is here
import 'package:open_core_hr/screens/SettingUp/setting_up_screen.dart'; // Next screen

import '../Utils/app_widgets.dart'; // For newEditTextDecoration, loadingWidgetMaker
import '../main.dart'; // For apiService, appStore, language, SharedKeys

class OrgChooseScreen extends StatefulWidget {
  const OrgChooseScreen({super.key});

  @override
  State<OrgChooseScreen> createState() => _OrgChooseScreenState();
}

class _OrgChooseScreenState extends State<OrgChooseScreen> {
  final TextEditingController _orgController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TenantModel> _tenants = []; // Store fetched tenants
  bool _isFetching = true; // Loading state for initial fetch
  bool _isProceeding = false; // Loading state for proceed button
  String? _fetchErrorMessage; // Error during initial fetch
  String? _validationError; // Error after clicking proceed

  @override
  void initState() {
    super.initState();
    if (isDemoMode) {
      _orgController.text = 'CZ App Studio';
    }
    _clearAndFetchDomains();
  }

  Future<void> _clearAndFetchDomains() async {
    setState(() {
      _isFetching = true;
      _fetchErrorMessage = null;
      _validationError = null; // Clear validation error on refetch
      _tenants = []; // Clear existing tenants before fetch
    });
    await _fetchDomains();
  }

  // Fetch all domains initially
  Future<void> _fetchDomains() async {
    try {
      _tenants = await apiService.getDomains();
      if (_tenants.isEmpty && mounted) {
        setState(() => _fetchErrorMessage = language.lblNoOrganizationFound);
      }
    } catch (e) {
      log("Error fetching domains: $e");
      if (mounted) {
        setState(() => _fetchErrorMessage =
            "Failed to load organizations. Please check connection.");
      }
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  // Verify input against fetched list and proceed
  Future<void> _verifyAndProceed() async {
    if (_isProceeding) return;
    if (_formKey.currentState?.validate() != true) return;

    final String query = _orgController.text.trim();
    if (query.isEmpty) return; // Should be caught by validator

    hideKeyboard(context);
    setState(() {
      _isProceeding = true;
      _validationError = null; // Clear previous validation error
    });

    TenantModel? foundTenant;

    // Search locally in the fetched list (case-insensitive for name/domain)
    final String lowerQuery = query.toLowerCase();
    for (var tenant in _tenants) {
      // Match against ID, Domain, or Tenant Name (adjust fields as needed)
      // Ensure type safety if ID is int vs String
      if (tenant.tenantId?.toString() == query ||
          tenant.domain?.toLowerCase() == lowerQuery ||
          tenant.tenantName?.toLowerCase() == lowerQuery) {
        foundTenant = tenant;
        break;
      }
    }

    if (foundTenant != null) {
      var selectedDomain = foundTenant;
      setValue('baseurl', '${selectedDomain.domain}/');
      setValue('organization', selectedDomain.tenantName);
      appStore.centralDomainURL = selectedDomain.tenantName;

      if (mounted) SettingUpScreen().launch(context, isNewTask: true);
    } else {
      // Domain Not Found in the list
      setState(() {
        _validationError = 'Organization not found'; // Set validation error
      });
    }

    // Ensure loading state is turned off if widget is still mounted
    if (mounted) {
      setState(() => _isProceeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Enter Organization', hideBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(), // Use helper for body content
      ),
    );
  }

  Widget _buildBody() {
    if (_isFetching) {
      return Center(child: loadingWidgetMaker());
    }

    if (_fetchErrorMessage != null) {
      // Error during initial fetch
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            16.height,
            Text(
              _fetchErrorMessage!,
              style: boldTextStyle(size: 16),
              textAlign: TextAlign.center,
            ),
            16.height,
            ElevatedButton(
              onPressed: _clearAndFetchDomains, // Retry fetching
              child: Text(language.lblRetry),
            )
          ],
        ),
      );
    }

    // If fetch succeeded (even if list is empty, show input)
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Enter your organization name',
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ),
          30.height,
          AppTextField(
            controller: _orgController,
            textFieldType: TextFieldType.NAME, // Or URL/OTHER
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Field is required';
              }
              // Reset validation error when user types
              if (_validationError != null) {
                setState(() => _validationError = null);
              }
              return null;
            },
            onFieldSubmitted: (s) => _verifyAndProceed(),
            decoration: newEditTextDecoration(
              Icons.business_outlined,
              'Organization',
              errorText: _validationError, // Display validation error directly
              // Clear error when field gains focus or changes
              // onTap: () { if (_validationError != null) setState(() => _validationError = null); },
            ),
            onChanged: (value) {
              // Clear error on change too
              if (_validationError != null)
                setState(() => _validationError = null);
            },
          ),
          30.height,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: appStore.appColorPrimary),
              onPressed: _isProceeding ? null : _verifyAndProceed,
              child: _isProceeding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(language.lblProceed,
                      style: primaryTextStyle(color: Colors.white)),
            ),
          ),
          /* // Optional: Display validation error below button as well
          if (_validationError != null) ...[
             16.height,
             Text(_validationError!, style: primaryTextStyle(color: Colors.red, size: 14)),
           ]
          */
          if (isDemoMode)
            const SizedBox(
              height: 16,
            ),
          if (isDemoMode)
            Text(
              'Demo Mode: Use "CZ App Studio" as organization name',
              style: primaryTextStyle(color: Colors.red, size: 14),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _orgController.dispose();
    super.dispose();
  }
}
