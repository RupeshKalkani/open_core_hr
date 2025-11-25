import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../Client/add_client_screen.dart';
import '../Client/client_search.dart';
import 'visit_store.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  final VisitStore _store = VisitStore();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  File? file;
  String filePath = '';

  final _clientCont = TextEditingController();
  final _remarksCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store.init();
  }

  Future<void> pickFile() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 65);
    if (photo != null) {
      setState(() {
        filePath = photo.path;
        file = File(photo.path);
      });
    }
  }

  void removeFile() {
    setState(() {
      filePath = '';
      file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblMarkVisit),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : _store.isClientsExists
                ? _buildForm()
                : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(language.lblToMarkVisitsPleaseAddClient,
              style: primaryTextStyle()),
          16.height,
          ElevatedButton(
            onPressed: () => const AddClientScreen().launch(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: appStore.appPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child:
                Text(language.lblAddClient, style: boldTextStyle(color: white)),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildClientField(),
            16.height,
            file != null ? _buildImagePreview() : _buildImagePicker(),
            16.height,
            _buildRemarksField(),
            24.height,
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientField() {
    return TextFormField(
      controller: _clientCont,
      readOnly: true,
      decoration: newEditTextDecoration(Icons.people, _store.clientLabel),
      onTap: () async {
        hideKeyboard(context);
        var result = await ClientSearch().launch(context);
        if (result != null && result is ClientModel) {
          setState(() {
            _store.selectedClient = result;
            _clientCont.text = result.name!;
          });
        }
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        decoration: cardDecoration(),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.lblClickToAddImage, style: primaryTextStyle()),
              const Icon(Icons.image, color: Colors.blue, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3,
            shape: buildCardCorner(),
            child: Image.file(file!, height: 200, fit: BoxFit.cover),
          ),
        ),
        10.width,
        Column(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.change_circle, size: 30, color: Colors.blue),
              onPressed: pickFile,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 30, color: Colors.red),
              onPressed: removeFile,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemarksField() {
    return TextFormField(
      controller: _remarksCont,
      maxLines: 2,
      decoration: newEditTextDecoration(Icons.comment, language.lblRemarks),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return language.lblRemarksIsRequired;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return button(
      language.lblSubmit,
      onTap: () async {
        if (_store.selectedClient == null) {
          toast(language.lblPleaseChooseClient);
          return;
        }
        if (filePath.isEmpty) {
          toast(language.lblImageIsRequired);
          return;
        }
        if (_formKey.currentState!.validate()) {
          var result = await _store.submit(filePath, _remarksCont.text, '0');
          if (result) {
            toast(language.lblSubmittedSuccessfully);
            globalAttendanceStore.refreshVisitsCount();
            if (!mounted) return;
            finish(context);
          }
        }
      },
    );
  }
}
