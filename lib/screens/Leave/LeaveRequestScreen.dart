import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/utils/app_widgets.dart';

import '../../main.dart';
import '../../models/leave_type_model.dart';

class LeaveRequestScreen extends StatefulWidget {
  static String tag = '/LeaveRequestScreen';
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  File? file;
  String fileName = '', filePath = '';
  bool _isLoading = false;
  bool _isImgRequired = false;
  final _formKey = GlobalKey<FormState>();

  late List<LeaveTypeModel> _leaveTypes;
  late int _selectedLeaveTypeId;

  final DateTime _today = DateTime.now();

  DateTime? _selectedFromDate;

  DateTime? _selectedToDate;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final _startDateCont = TextEditingController();
  final _endDateCont = TextEditingController();
  final _commentsCont = TextEditingController();
  final _fileUploadCont = TextEditingController();

  final _startDateNode = FocusNode();
  final _endDateNode = FocusNode();
  final _commentsNode = FocusNode();
  final _fileUploadNode = FocusNode();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });

    var result = await apiService.getLeaveTypes();
    if (result.isNotEmpty) {
      _leaveTypes = result;
      _selectedLeaveTypeId = _leaveTypes.first.id!;
      _isImgRequired = _leaveTypes.first.isImgRequired!;
    } else {
      _leaveTypes = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  sendLeaveRequest() async {
    hideKeyboard(context);
    setState(() {
      _isLoading = true;
    });

    var req = {
      "fromDate": _startDateCont.text,
      "toDate": _endDateCont.text,
      "leaveType": _selectedLeaveTypeId,
      "comments": _commentsCont.text
    };

    var result = await apiService.sendLeaveRequest(req);
    if (result) {
      var leaveType =
          _leaveTypes.where((e) => e.id == _selectedLeaveTypeId).first;

      if (leaveType.isImgRequired!) {
        //Upload leave document api call
        var result = await apiService.uploadLeaveDocument(filePath);
        if (result) {
          toast(language.lblRequestSuccessfullySubmitted);
        } else {
          toast(language.lblSomethingWentWrongWhileUploadingTheFile);
        }
        if (!mounted) return;
        finish(context);
        return;
      }
      toast(language.lblRequestSuccessfullySubmitted);
      if (!mounted) return;
      finish(context);
    } else {
      toast(language.lblPleaseTryAgainLater);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future getFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      file = File(result.files.single.path!);
      fileName = file!.path.split('/').last;
      filePath = file!.path;

      _fileUploadCont.text = fileName;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblLeaveRequest),
      body: !_isLoading
          ? _leaveTypes.isEmpty
              ? Center(
                  child: Text(language.lblNoLeaveTypesAreConfigured),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            onTap: () {
                              hideKeyboard(context);
                              _selectFromDate(context);
                            },
                            controller: _startDateCont,
                            focusNode: _startDateNode,
                            style: primaryTextStyle(),
                            decoration: newEditTextDecoration(
                                Icons.calendar_month, language.lblFrom),
                            cursorColor:
                                appStore.isDarkModeOn ? white : blackColor,
                          ),
                          10.height,
                          TextFormField(
                            onTap: () {
                              hideKeyboard(context);
                              _selectToDate(context);
                            },
                            controller: _endDateCont,
                            focusNode: _endDateNode,
                            style: primaryTextStyle(),
                            decoration: newEditTextDecoration(
                                Icons.calendar_month, language.lblTo),
                            cursorColor:
                                appStore.isDarkModeOn ? white : blackColor,
                          ),
                          10.height,
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonFormField(
                                items: _leaveTypes.map((item) {
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
                                  newValue as LeaveTypeModel;
                                  // do other stuff with _category
                                  setState(() {
                                    _selectedLeaveTypeId = newValue.id!;
                                    _isImgRequired = newValue.isImgRequired!;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                value: _leaveTypes.first,
                                decoration: newEditTextDecoration(
                                  Icons.table_chart,
                                  language.lblLeaveType,
                                ),
                              );
                            },
                          ),
                          10.height,
                          TextFormField(
                            controller: _commentsCont,
                            focusNode: _commentsNode,
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
                          _isImgRequired
                              ? TextFormField(
                                  onTap: () async {
                                    hideKeyboard(context);
                                    await getFile();
                                    setState(() {});
                                  },
                                  controller: _fileUploadCont,
                                  focusNode: _fileUploadNode,
                                  style: primaryTextStyle(),
                                  decoration: newEditTextDecoration(
                                      Icons.upload_file,
                                      language.lblChooseImage),
                                  validator: (s) {
                                    if (_isImgRequired && s!.trim().isEmpty) {
                                      return language.lblImageIsRequired;
                                    }
                                    return null;
                                  },
                                )
                              : Container(),
                          10.height,
                          AppButton(
                              text: language.lblSubmit,
                              color: appStore.appColorPrimary,
                              textColor: Colors.white,
                              shapeBorder: buildButtonCorner(),
                              width: 120,
                              onTap: () async {
                                hideKeyboard(context);
                                if (_selectedFromDate == null) {
                                  toast(language.lblPleaseSelectFromDate);
                                  return;
                                }
                                if (_selectedToDate == null) {
                                  toast(language.lblPleaseSelectToDate);
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  await sendLeaveRequest();
                                }
                              }),
                          15.height,
                        ],
                      ),
                    ),
                  ),
                )
          : loadingWidgetMaker(),
    );
  }
  //Methods

  //Methods
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        helpText: language.lblLeaveFrom,
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
        initialDate: _today.add(const Duration(days: 1)),
        firstDate: _today.add(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null) {
      _selectedFromDate = picked;
      if (!_selectedFromDate!.isAfter(_today)) {
        toast(language.lblYouCannotSelectOlderDates);
        return;
      } else {
        setState(() {
          _selectedFromDate = picked;
          _startDateCont.text = formatter.format(_selectedFromDate!);
        });
      }
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (_selectedFromDate == null) {
      toast(language.lblPleaseSelectFromDateFirst);
      return;
    }
    final DateTime? picked = await showDatePicker(
        helpText: language.lblLeaveTo,
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
        initialDate: _selectedFromDate,
        firstDate: _selectedFromDate!,
        lastDate: DateTime(2101));
    if (picked != null) {
      _selectedToDate = picked;
      if (!_selectedToDate!.isAfter(_today)) {
        toast(language.lblYouCannotSelectOlderDates);
        return;
      } else {
        setState(() {
          _selectedToDate = picked;
          _endDateCont.text = formatter.format(_selectedToDate!);
        });
      }
    }
  }
}
