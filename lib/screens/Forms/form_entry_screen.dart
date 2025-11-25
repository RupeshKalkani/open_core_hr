import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/Widgets/text_widget.dart';
import 'package:open_core_hr/models/Form/form_model.dart';
import 'package:open_core_hr/screens/Forms/forms_store.dart';

import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../Client/client_search.dart';

class FormEntryScreen extends StatefulWidget {
  final FormModel form;
  const FormEntryScreen({super.key, required this.form});

  @override
  State<FormEntryScreen> createState() => _FormEntryScreenState();
}

class _FormEntryScreenState extends State<FormEntryScreen> {
  final _store = FormsStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    for (var element in widget.form.formFields!) {
      element.controller = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.form.name.toString()),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 5,
        radius: const Radius.circular(20),
        scrollbarOrientation: ScrollbarOrientation.right,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.form.description.toString(),
                style: primaryTextStyle(),
              ).paddingOnly(top: 16, bottom: 16),
              Form(
                key: _store.formKey,
                child: Column(
                  children: [
                    if (widget.form.isClientRequired!)
                      Column(
                        children: [
                          13.height,
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _store.clientController,
                            decoration: newEditTextDecorationNoIcon(
                                language.lblClient,
                                hint: language.lblSelectClient),
                            validator: (s) {
                              if (widget.form.isClientRequired!) {
                                if (s == null || s.isEmpty) {
                                  return language.lblPleaseChooseClient;
                                }
                              }
                              return null;
                            },
                            onTap: () async {
                              hideKeyboard(context);
                              var result = await ClientSearch().launch(context);
                              if (result != null && result is ClientModel) {
                                setState(() {
                                  _store.selectedClient = result;
                                  _store.clientController.text = result.name!;
                                });
                              }
                              //init();
                            },
                          ),
                          13.height
                        ],
                      ),
                    ListView.builder(
                        itemCount: widget.form.formFields!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var field = widget.form.formFields![index];
                          // return Text(field.type.toString());
                          return Column(
                            children: [buildFormField(field, index), 13.height],
                          );
                        }),
                  ],
                ),
              ),
              Observer(
                builder: (_) => _store.isBtnLoading
                    ? loadingWidgetMaker()
                    : AppButton(
                        color: appStore.appColorPrimary,
                        shapeBorder: buildButtonCorner(),
                        text: language.lblSubmit,
                        textColor: white,
                        onTap: () async {
                          hideKeyboard(context);
                          if (!_store.formKey.currentState!.validate()) {
                            return;
                          }
                          var result =
                              await _store.submitForm(widget.form.formId!);
                          if (!mounted) return;
                          if (result) {
                            toast(language.lblFormSubmittedSuccessfully);
                            finish(context);
                          }
                        },
                      ),
              )
            ],
          ).paddingOnly(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget buildFormField(FormFieldModel field, index) {
    String type = field.type!.toLowerCase();
    switch (type) {
      case 'text':
        return TextFormField(
          keyboardType: TextInputType.text,
          controller: field.controller,
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            return null;
          },
          onChanged: (value) {
            _store.addUpdateEntry(field.id!, value);
          },
        );
      case 'number':
        return TextFormField(
          keyboardType: TextInputType.number,
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            if (s != null && s.isNotEmpty) {
              //Number only check regex
              var regex = RegExp(r'^[0-9]+$');
              if (!regex.hasMatch(s)) {
                return language.lblPleaseEnterValidNumber;
              }
            }
            return null;
          },
          onChanged: (value) {
            _store.addUpdateEntry(field.id!, value);
          },
        );
      case 'date':
        return TextFormField(
          keyboardType: TextInputType.datetime,
          controller: field.controller,
          onTap: () async {
            hideKeyboard(context);
            var result = await pickDate(context);
            if (result != null) {
              _store.addUpdateEntry(field.id!, formatter.format(result));
              field.controller ??= TextEditingController();
              field.controller!.text = formatter.format(result);
            }
          },
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            return null;
          },
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
        );
      case 'time':
        return TextFormField(
          keyboardType: TextInputType.datetime,
          controller: field.controller,
          onTap: () async {
            hideKeyboard(context);
            var result = await pickTime(context);
            if (!mounted) return;
            if (result != null) {
              _store.addUpdateEntry(field.id!, result.format(context));
              field.controller ??= TextEditingController();
              field.controller!.text = result.format(context);
            }
          },
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            return null;
          },
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
        );
      case 'boolean':
        _store.addUpdateEntry(field.id!, false.toString());
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field.label.toString(),
              style: primaryTextStyle(),
            ),
            Switch(
                value: field.switchValue,
                onChanged: (value) {
                  setState(() {
                    field.switchValue = value;
                  });
                  _store.addUpdateEntry(field.id!, value.toString());
                })
          ],
        ).paddingOnly(left: 4);

      case 'select':
        return DropdownButtonFormField<dynamic>(
            decoration: newEditTextDecorationNoIcon(field.label.toString(),
                hint: field.placeholder),
            items: field.values!.map((dynamic value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (s) {
              if (field.isRequired!) {
                if (s == null || s.isEmpty) {
                  return '${language.lblPleaseEnter} ${field.label}';
                }
              }
              return null;
            },
            onChanged: (value) {
              _store.addUpdateEntry(field.id!, value);
            });
      case 'multiselect':
        final List<ValueItem> items = field.values!
            .map(
              (e) => ValueItem(
                label: e.toString(),
                value: e.toString(),
              ),
            )
            .toList();
        return MultiSelectDropDown(
          controller: field.multiSelectController,
          onOptionSelected: (options) {
            List<String> items = [];
            for (var item in options) {
              items.add(item.value.toString());
            }
            _store.addUpdateEntry(field.id!, items.toString());
          },
          options: items,
          hint: field.placeholder.toString(),
          selectionType: SelectionType.multi,
          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
          dropdownHeight: 300,
          optionTextStyle: const TextStyle(fontSize: 16),
          selectedOptionIcon: const Icon(Icons.check_circle),
        );
      case 'url':
        return TextFormField(
          keyboardType: TextInputType.url,
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
              if (!s.validateURL()) {
                return language.lblPleaseEnterValidURL;
              }
            }

            if (s != null && s.isNotEmpty) {
              if (!s.validateURL()) {
                return language.lblPleaseEnterValidURL;
              }
            }
            return null;
          },
          onChanged: (value) {
            _store.addUpdateEntry(field.id!, value);
          },
        );
      case 'email':
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            if (!s.isEmptyOrNull) {
              if (!s.validateEmail()) {
                return language.lblPleaseEnterValidEmail;
              }
            }
            return null;
          },
          onChanged: (value) {
            _store.addUpdateEntry(field.id!, value);
          },
        );
      case 'address':
        return TextFormField(
          keyboardType: TextInputType.multiline,
          decoration: newEditTextDecorationNoIcon(field.label.toString(),
              hint: field.placeholder),
          maxLines: 2,
          validator: (s) {
            if (field.isRequired!) {
              if (s == null || s.isEmpty) {
                return '${language.lblPleaseEnter} ${field.label}';
              }
            }
            return null;
          },
          onChanged: (value) {
            _store.addUpdateEntry(field.id!, value);
          },
        );

      default:
        return Text(field.type.toString());
    }
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        fieldHintText: 'Month/Date/Year',
        context: context,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: child,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null) {
      return picked;
    }
    return null;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    return picked;
  }
}
