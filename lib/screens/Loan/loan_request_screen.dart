import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_widgets.dart';
import '../../Widgets/button_widget.dart';
import '../../main.dart';
import 'loan_store.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _store = LoanStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblRequestLoan),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _store.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _store.amountController,
                  focusNode: _store.amountFocusNode,
                  style: primaryTextStyle(),
                  keyboardType: TextInputType.number,
                  decoration: newEditTextDecoration(
                    Icons.money,
                    language.lblEnterAmount,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return language.lblAmountCannotBeEmpty;
                    }
                    return null;
                  },
                ),
                10.height,
                TextFormField(
                  controller: _store.remarksController,
                  focusNode: _store.remarksFocusNode,
                  style: primaryTextStyle(),
                  decoration: newEditTextDecoration(
                    Icons.note,
                    language.lblRemarks,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return language.lblRemarksIsRequired;
                    }
                    return null;
                  },
                ),
                10.height,
                button(
                  language.lblSubmit,
                  onTap: () async {
                    if (_store.formKey.currentState!.validate()) {
                      var result = await _store.requestLoan();
                      if (result) {
                        toast(language.lblLoanRequestSubmittedSuccessfully);
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    }
                  },
                  color: appStore.appColorPrimary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
