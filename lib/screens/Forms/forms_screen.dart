import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/screens/Forms/forms_store.dart';

import '../../Utils/app_widgets.dart';
import '../../models/Form/form_model.dart';
import 'form_entry_screen.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _store = FormsStore();

  @override
  void initState() {
    super.initState();
    _store.loadForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblForms),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : _store.forms.isEmpty
                ? Center(
                    child: noDataWidget(message: language.lblNoFormsAssigned))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _store.forms.length,
                    itemBuilder: (context, index) => buildFormCard(
                      context,
                      _store.forms[index],
                      () => _store.loadForms(),
                    ),
                  ),
      ),
    );
  }
}

Widget buildFormCard(
    BuildContext context, FormModel form, VoidCallback callBack) {
  return Container(
    decoration: cardDecoration(),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        if (!globalAttendanceStore.isCheckedIn) {
          toast(language.lblPleaseCheckInFirst);
          return;
        }
        await FormEntryScreen(form: form).launch(context);
        callBack();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Section with Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
            16.width,
            // Middle Section - Form Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.name ?? '',
                    style: boldTextStyle(size: 18),
                  ),
                  6.height,
                  Text(
                    '${language.lblDescription}: ${form.description ?? language.lblNoDescription}',
                    style: secondaryTextStyle(size: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.height,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${language.lblFormId}: ${form.formId}',
                          style: secondaryTextStyle(
                              size: 12, color: Colors.blueAccent),
                        ),
                      ),
                      8.width,
                      Row(
                        children: [
                          const Icon(Icons.assignment_outlined,
                              size: 16, color: Colors.grey),
                          4.width,
                          Text(
                            '${form.entriesCount} ${language.lblSubmissions}',
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
