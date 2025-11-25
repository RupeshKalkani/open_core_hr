import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isLoading = false;

  var oldPasswordCont = TextEditingController();

  var newPasswordCont = TextEditingController();

  var confirmNewPasswordCont = TextEditingController();

  var oldPasswordNode = FocusNode();

  var newPasswordNode = FocusNode();

  var confirmNewPasswordNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  init() async {}

  Future changePassword() async {
    var result = await apiService.changePassword(
        oldPasswordCont.text, confirmNewPasswordCont.text);
    if (result) {
      toast(language.lblPasswordChangedSuccessfully);
      if (!mounted) return;
      finish(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblChangePassword),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            10.height,
            TextFormField(
              controller: oldPasswordCont,
              focusNode: oldPasswordNode,
              style: TextStyle(
                  fontSize: fontSizeLargeMedium,
                  fontFamily: fontRegular,
                  color: appStore.textPrimaryColor),
              decoration:
                  newEditTextDecoration(Icons.lock, language.lblOldPassword),
              validator: (s) {
                if (s.isEmptyOrNull) {
                  return language.lblOldPasswordIsRequired;
                }

                if (s!.length < 5) {
                  return language.lblInvalidPassword;
                }
                return null;
              },
            ),
            12.height,
            TextFormField(
              controller: newPasswordCont,
              focusNode: newPasswordNode,
              style: TextStyle(
                  fontSize: fontSizeLargeMedium,
                  fontFamily: fontRegular,
                  color: appStore.textPrimaryColor),
              decoration:
                  newEditTextDecoration(Icons.lock, language.lblNewPassword),
              validator: (s) {
                if (s.isEmptyOrNull) {
                  return language.lblNewPasswordIsRequired;
                }

                if (s!.length < 5) {
                  return '${language.lblMinimumLengthIs} 5';
                }
                return null;
              },
            ),
            12.height,
            TextFormField(
              controller: confirmNewPasswordCont,
              focusNode: confirmNewPasswordNode,
              style: TextStyle(
                  fontSize: fontSizeLargeMedium,
                  fontFamily: fontRegular,
                  color: appStore.textPrimaryColor),
              decoration: newEditTextDecoration(
                  Icons.lock, language.lblConfirmNewPassword),
              validator: (s) {
                if (s.isEmptyOrNull) {
                  return language.lblConfirmPasswordIsRequired;
                }

                if (s != newPasswordCont.text) {
                  return language.lblPasswordDoesNotMatch;
                }

                return null;
              },
            ),
            15.height,
            !isLoading
                ? AppButton(
                    text: language.lblChange,
                    color: appStore.appColorPrimary,
                    elevation: 10,
                    textColor: Colors.white,
                    shapeBorder: buildButtonCorner(),
                    width: 150,
                    onTap: () async {
                      hideKeyboard(context);
                      isLoading = true;
                      if (_formKey.currentState!.validate()) {
                        changePassword();
                      }
                      isLoading = false;
                    })
                : loadingWidgetMaker(),
          ],
        ).paddingOnly(left: 10, right: 10),
      ),
    );
  }
}
