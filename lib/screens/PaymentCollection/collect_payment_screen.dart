import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';
import 'package:open_core_hr/screens/PaymentCollection/collection_store.dart';

import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../Client/client_search.dart';

class CollectPaymentScreen extends StatefulWidget {
  const CollectPaymentScreen({super.key});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  final _store = CollectionStore();

  @override
  void initState() {
    super.initState();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblCollectPayment),
      body: SingleChildScrollView(
        child: Observer(
          builder: (_) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _store.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _store.clientController,
                    focusNode: _store.clientFocusNode,
                    onTap: () async {
                      hideKeyboard(context);
                      var result = await ClientSearch().launch(context);
                      if (result != null && result is ClientModel) {
                        setState(() {
                          _store.selectedClient = result;
                          _store.clientController.text = result.name!;
                        });
                      }
                      init();
                    },
                    style: primaryTextStyle(),
                    decoration: newEditTextDecoration(
                      Icons.people,
                      language.lblSelectClient,
                    ),
                  ),
                  10.height,
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
                        return language.lblAmountIsRequired;
                      }
                      return null;
                    },
                  ),
                  10.height,
                  DropdownButtonFormField<String>(
                    focusNode: _store.paymentModeFocusNode,
                    items: _store.paymentModes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _store.paymentModeController.text = value!;
                    },
                    value: _store.paymentModes.first,
                    decoration: newEditTextDecoration(
                      Icons.payment,
                      language.lblSelectPaymentMode,
                    ),
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
                  ),
                  10.height,
                  button(
                    language.lblSubmit,
                    onTap: () async {
                      if (_store.formKey.currentState!.validate()) {
                        var result = await _store.createCollection();
                        if (result) {
                          toast(language.lblSuccessfullyCreated);
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
      ),
    );
  }
}
