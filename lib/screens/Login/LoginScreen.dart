import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';
import 'package:open_core_hr/screens/Device/device_verification_screen.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_images.dart';
import '../ForgotPassword/ForgotPassword.dart';
import '../language_screen.dart';
import '../org_choose_screen.dart';
import 'LoginStore.dart';

class LoginScreen extends StatefulWidget {
  final bool isDeviceVerified;
  static String tag = '/LoginScreen';

  const LoginScreen({super.key, this.isDeviceVerified = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginStore _loginStore = LoginStore();
  var selectedLanguage = getSelectedLanguageModel();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await sharedHelper.refreshAppSettings();
    await moduleService.refreshModuleSettings();
    _loginStore.setupValidations();
  }

  Widget demoModeWidget() {
    return Column(
      children: [
        Column(
          children: [
            Text(
              'App is in demo mode',
              style: boldTextStyle(
                size: 16,
                color: white,
              ),
              textAlign: TextAlign.center,
            ),
            8.height,
            Text(
              'You can login with demo employee id and password',
              style: secondaryTextStyle(size: 14, color: white),
              textAlign: TextAlign.center,
            ),
            8.height,
            Observer(
              builder: (_) => _loginStore.isDemoRegisterBtnLoading
                  ? loadingWidgetMaker()
                  : button(
                      'Register as a demo employee',
                      color: Colors.red,
                      onTap: () async {
                        var result = await _loginStore.createDemoUser();
                        if (result.toLowerCase() == 'active') {
                          if (!mounted) return;
                          sharedHelper.refreshAppSettings();
                          const DeviceVerificationScreen()
                              .launch(context, isNewTask: true);
                        }
                      },
                    ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.appColorPrimary);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: context.width(),
        height: context.height(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appStore.appColorPrimary, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // **Language Switcher at the Top**
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        selectedLanguage != null &&
                                selectedLanguage!.flag != null
                            ? selectedLanguage!.flag!
                            : 'images/flags/ic_us.png',
                        height: 24,
                        width: 24,
                      ),
                      8.width,
                      Text(
                        selectedLanguage != null
                            ? selectedLanguage!.name!
                            : 'English',
                        style: boldTextStyle(color: white),
                      ),
                      8.width,
                      Icon(Icons.keyboard_arrow_down, color: white),
                    ],
                  ).onTap(
                    () async {
                      const LanguageScreen().launch(context);
                    },
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Observer(
                      builder: (_) => Column(
                        children: [
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // **App Logo**
                                  getStringAsync(appCompanyLogoPref).isNotEmpty
                                      ? Image.network(
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : buildShimmer(90, 90);
                                          },
                                          height: 90,
                                          getStringAsync(appCompanyLogoPref),
                                        )
                                      : Image.asset(
                                          appLogoImg,
                                          height: 90,
                                          width: 90,
                                        ),
                                  12.height,
                                  Text(
                                    getStringAsync(appCompanyNamePref).isEmpty
                                        ? mainAppName
                                        : getStringAsync(appCompanyNamePref),
                                    style: boldTextStyle(
                                        size: 24,
                                        color: appStore.appColorPrimary),
                                  ),
                                  24.height,

                                  // **Device Verified Case**
                                  widget.isDeviceVerified
                                      ? Column(
                                          children: [
                                            Lottie.asset(
                                              'assets/animations/screen_tap.json',
                                              height: 150,
                                              repeat: true,
                                            ),
                                            16.height,
                                            Text(
                                              language
                                                  .lblLooksLikeYouAlreadyRegisteredThisDeviceYouCanUseOneTapLogin,
                                              textAlign: TextAlign.center,
                                              style:
                                                  secondaryTextStyle(size: 14),
                                            ),
                                            20.height,
                                            _loginStore.isLoginWithUidBtnLoading
                                                ? loadingWidgetMaker()
                                                : AppButton(
                                                    text:
                                                        language.lblOneTapLogin,
                                                    color: appStore
                                                        .appColorPrimary,
                                                    elevation: 4,
                                                    textColor: Colors.white,
                                                    shapeBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    onTap: () async {
                                                      hideKeyboard(context);
                                                      var result =
                                                          await _loginStore
                                                              .loginWithUid();
                                                      sharedHelper
                                                          .routeBasedOnStatus(
                                                              context, result);
                                                    },
                                                  ),
                                            12.height,
                                            Text(
                                              language
                                                  .lblIfYouWantToLoginWithDifferentAccountPleaseContactAdministrator,
                                              textAlign: TextAlign.center,
                                              style:
                                                  secondaryTextStyle(size: 12),
                                            ),
                                          ],
                                        )
                                      // **Regular Login Form**
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              language.lblPleaseLoginToContinue,
                                              style: primaryTextStyle(size: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            20.height,
                                            Observer(
                                              builder: (_) => AppTextField(
                                                textFieldType:
                                                    TextFieldType.EMAIL,
                                                onChanged: (value) =>
                                                    _loginStore.employeeId =
                                                        value,
                                                decoration:
                                                    newEditTextDecoration(
                                                  Icons.person_outline,
                                                  language.lblEmail,
                                                  errorText: _loginStore
                                                      .error.employeeId,
                                                ),
                                              ),
                                            ),
                                            16.height,
                                            Observer(
                                              builder: (_) => AppTextField(
                                                isPassword: true,
                                                textFieldType:
                                                    TextFieldType.PASSWORD,
                                                onChanged: (value) =>
                                                    _loginStore.password =
                                                        value,
                                                obscureText: true,
                                                decoration:
                                                    newEditTextDecoration(
                                                  Icons.lock_outline,
                                                  language.lblPassword,
                                                  errorText: _loginStore
                                                      .error.password,
                                                ),
                                              ),
                                            ),
                                            24.height,
                                            _loginStore.isLoading ||
                                                    _loginStore
                                                        .isDemoRegisterBtnLoading ||
                                                    _loginStore
                                                        .isLoginWithUidBtnLoading
                                                ? loadingWidgetMaker()
                                                : AppButton(
                                                    text: language.lblLogin,
                                                    color: appStore
                                                        .appColorPrimary,
                                                    elevation: 4,
                                                    textColor: Colors.white,
                                                    shapeBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    onTap: () async {
                                                      hideKeyboard(context);
                                                      _loginStore.validateAll();
                                                      if (_loginStore
                                                          .canLogin) {
                                                        var result =
                                                            await _loginStore
                                                                .login();
                                                        sharedHelper
                                                            .routeBasedOnStatus(
                                                                context,
                                                                result);
                                                      }
                                                    },
                                                  ),
                                            20.height,
                                            GestureDetector(
                                              onTap: () {
                                                const ForgotPassword()
                                                    .launch(context);
                                              },
                                              child: Text(
                                                "${language.lblForgotPassword} ?",
                                                style: boldTextStyle(
                                                    size: 14,
                                                    color: Colors.blueAccent),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          if (isDemoMode && !widget.isDeviceVerified)
                            demoModeWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (isSaaSMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appStore.centralDomainURL,
                        style: boldTextStyle(size: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      2.width,
                      const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  ),
                ).onTap(() {
                  OrgChooseScreen().launch(context);
                }),
            ],
          ),
        ),
      ),
    );
  }
}
