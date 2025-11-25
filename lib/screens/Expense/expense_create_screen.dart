import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/models/Expense/expense_type_model.dart';

import '../../utils/app_widgets.dart';
import 'ExpenseStore.dart';

class ExpenseCreateScreen extends StatefulWidget {
  static String tag = '/ExpenseCreateScreen';
  const ExpenseCreateScreen({super.key});

  @override
  State<ExpenseCreateScreen> createState() => _ExpenseCreateScreenState();
}

class _ExpenseCreateScreenState extends State<ExpenseCreateScreen> {
  final ExpenseStore _store = ExpenseStore();

  final _formKey = GlobalKey<FormState>();

  final _dateCont = TextEditingController();
  final _remarksCont = TextEditingController();
  final _fileUploadCont = TextEditingController();
  final _amountCont = TextEditingController();

  final _remarksFocus = FocusNode();
  final _fileUploadNode = FocusNode();
  final _dateFocus = FocusNode();
  final _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await _store.loadExpenseTypes();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        helpText: language.lblDate,
        cancelText: language.lblCancel,
        confirmText: language.lblChoose,
        fieldLabelText: language.lblFromDate,
        fieldHintText: 'Month/Date/Year',
        errorFormatText: language.lblEnterValidDate,
        errorInvalidText: language.lblEnterDateInValidRange,
        context: context,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: child,
          );
        },
        initialDate: _store.today,
        firstDate: DateTime(2000),
        lastDate: _store.today);
    if (picked != null && picked != _store.selectedDate) {
      _store.selectedDate = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblCreateExpense),
      body: Observer(
        builder: (_) => !_store.isLoading
            ? _store.expenseTypes.isEmpty
                ? Center(child: Text(language.lblNoExpenseTypesAreConfigured))
                : Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onTap: () async {
                                hideKeyboard(context);
                                await selectDate(context);
                                _dateCont.text = _store.formatter
                                    .format(_store.selectedDate);
                              },
                              controller: _dateCont,
                              focusNode: _dateFocus,
                              style: primaryTextStyle(),
                              decoration: newEditTextDecoration(
                                  Icons.calendar_month, language.lblDate),
                              cursorColor:
                                  appStore.isDarkModeOn ? white : blackColor,
                            ),
                            10.height,
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return DropdownButtonFormField(
                                  items: _store.expenseTypes.map((item) {
                                    return DropdownMenuItem(
                                        value: item,
                                        child: Row(
                                          children: <Widget>[
                                            Text(item.name!),
                                          ],
                                        ));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    newValue as ExpenseTypeModel;
                                    // do other stuff with _category
                                    _store.selectedExpenseType = newValue;
                                    _store.isImgRequired =
                                        newValue.isImgRequired!;
                                  },
                                  borderRadius: BorderRadius.circular(20.0),
                                  value: _store.expenseTypes.first,
                                  decoration: newEditTextDecoration(
                                      Icons.table_chart,
                                      language.lblExpenseType),
                                );
                              },
                            ),
                            10.height,
                            TextFormField(
                              controller: _amountCont,
                              focusNode: _amountFocus,
                              style: primaryTextStyle(),
                              decoration: newEditTextDecoration(
                                  Icons.monetization_on_sharp,
                                  language.lblAmount),
                              cursorColor:
                                  appStore.isDarkModeOn ? white : blackColor,
                              keyboardType: TextInputType.number,
                              validator: (s) {
                                if (s!.trim().isEmpty) {
                                  return language.lblAmountIsRequired;
                                }
                                return null;
                              },
                            ),
                            10.height,
                            TextFormField(
                              controller: _remarksCont,
                              focusNode: _remarksFocus,
                              style: primaryTextStyle(),
                              decoration: newEditTextDecoration(
                                  Icons.receipt, language.lblRemarks),
                              cursorColor:
                                  appStore.isDarkModeOn ? white : blackColor,
                              keyboardType: TextInputType.name,
                              validator: (s) {
                                if (s!.trim().isEmpty) {
                                  return language.lblRemarksIsRequired;
                                }
                                return null;
                              },
                            ),
                            10.height,
                            Observer(
                              builder: (_) => _store.isImgRequired
                                  ? TextFormField(
                                      onTap: () async {
                                        hideKeyboard(context);
                                        await _store.getFile();
                                        _fileUploadCont.text = _store.fileName;
                                      },
                                      controller: _fileUploadCont,
                                      focusNode: _fileUploadNode,
                                      style: primaryTextStyle(),
                                      decoration: newEditTextDecoration(
                                          Icons.upload_file,
                                          language.lblChooseImage),
                                      validator: (s) {
                                        if (_store.isImgRequired &&
                                            s!.trim().isEmpty) {
                                          return language.lblImageIsRequired;
                                        }
                                        return null;
                                      },
                                    )
                                  : Container(),
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
                                  if (_formKey.currentState!.validate()) {
                                    var result =
                                        await _store.sendExpenseRequest(
                                            _amountCont.text.trim(),
                                            _remarksCont.text.trim());
                                    if (result) {
                                      toast(language.lblSubmittedSuccessfully);
                                      if (!mounted) return;
                                      finish(context);
                                    }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
            : loadingWidgetMaker(),
      ),
    );
  }
}
