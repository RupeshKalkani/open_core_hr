import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Document/document_type_model.dart';
import 'document_store.dart';

class CreateDocumentRequestScreen extends StatefulWidget {
  const CreateDocumentRequestScreen({super.key});

  @override
  State<CreateDocumentRequestScreen> createState() =>
      _CreateDocumentRequestScreenState();
}

class _CreateDocumentRequestScreenState
    extends State<CreateDocumentRequestScreen> {
  final _store = DocumentStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _store.getDocumentTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblRequestADocument),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : _store.documentTypes.isEmpty
                ? Center(
                    child: Text(language.lblNoDocumentTypesAdded),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _store.formKey,
                      child: Column(
                        children: [
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonFormField(
                                items: _store.documentTypes.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Row(
                                      children: <Widget>[
                                        Text(item.name!),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  newValue as DocumentTypeModel;
                                  _store.selectedTypeId = newValue.id;
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                value: _store.documentTypes.first,
                                decoration: newEditTextDecoration(
                                    Icons.table_chart,
                                    language.lblDocumentType),
                              );
                            },
                          ),
                          10.height,
                          TextFormField(
                            controller: _store.commentsCont,
                            focusNode: _store.commentsNode,
                            style: primaryTextStyle(),
                            decoration: newEditTextDecoration(
                                Icons.receipt, language.lblRemarks),
                            cursorColor:
                                appStore.isDarkModeOn ? white : blackColor,
                            keyboardType: TextInputType.name,
                            validator: (s) {
                              if (s!.trim().isEmpty) {
                                return language.lblCommentsIsRequired;
                              }
                              return null;
                            },
                          ),
                          10.height,
                          AppButton(
                              text: language.lblSubmit,
                              color: appStore.appColorPrimary,
                              textColor: Colors.white,
                              shapeBorder: buildButtonCorner(),
                              width: 120,
                              onTap: () async {
                                hideKeyboard(context);
                                if (_store.formKey.currentState!.validate()) {
                                  var result =
                                      await _store.sendDocumentRequest();
                                  if (!mounted) return;
                                  if (result) {
                                    toast(language
                                        .lblDocumentRequestSubmittedSuccessfully);
                                    finish(context);
                                  }
                                }
                              }),
                          15.height,
                        ],
                      ),
                    ).paddingAll(16),
                  ),
      ),
    );
  }
}
