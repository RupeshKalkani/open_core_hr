import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:validators/validators.dart';

import '../../api/api_routes.dart';
import '../../main.dart';
import '../../models/api_response_model.dart';
import '../../models/user_model.dart';
import '../../utils/app_constants.dart';

part 'LoginStore.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final LoginFormError error = LoginFormError();

  @observable
  bool isValidDevice = false;

  @observable
  bool isDemoRegisterBtnLoading = false;

  @observable
  bool isLoading = false;

  @observable
  bool isLoginWithUidBtnLoading = false;

  @observable
  String? employeeId;

  @observable
  ObservableFuture<bool> employeeIdCheck = ObservableFuture.value(true);

  @observable
  String? passwordError;

  @observable
  String? password;

  @observable
  bool isDeviceVerified = false;

  @computed
  bool get isPhoneNumberCheckPending =>
      employeeIdCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  List<ReactionDisposer> _disposers = [];

  void setupValidations() {
    _disposers = [
      reaction((_) => employeeId, validateEmployeeId),
      reaction((_) => password, validatePassword)
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validateEmployeeId(employeeId);
    validatePassword(password);
  }

  Future validateEmployeeId(String? value) async {
    if (isNull(value) || value == '') {
      error.employeeId = language.lblCannotBeBlank;
      return;
    }

    if (value != null && value.length < 6) {
      error.employeeId = language.lblInvalidEmployeeId;
      return;
    }

    try {
      employeeIdCheck =
          ObservableFuture(apiService.checkValidEmployeeId(value!));
      final isValid = await employeeIdCheck;
      if (!isValid) {
        error.employeeId = language.lblEmployeeIdDoesNotExists;
        return;
      }
      error.employeeId = null;
    } on Object catch (_) {
      error.employeeId = null;
    }

    error.employeeId = null;
  }

  Future validatePassword(String? password) async {
    if (isNull(password) || password == '') {
      error.password = language.lblCannotBeBlank;
      return;
    }

    if (password != null) {
      if (password.isNotEmpty && password.length < 6) {
        error.password = language.lblInvalidPassword;
        return;
      }
    }

    error.password = null;
  }

  Future<String> login() async {
    isLoading = true;
    Map payload = {
      'employeeId': employeeId!.trim(),
      'password': password!.trim()
    };

    String body = json.encode(payload);

    var baseUrl = APIRoutes.baseURL + APIRoutes.loginURL;
    if (isSaaSMode) {
      baseUrl = '${getStringAsync('baseurl')}api/V1/${APIRoutes.loginURL}';
    }

    Response response = await post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
        encoding: Encoding.getByName("utf-8"));

    int statusCode = response.statusCode;

    log('Status Code: $statusCode');

    log('Response: ${response.body}');

    var data = jsonDecode(response.body);

    ApiResponseModel apiResponse = ApiResponseModel.fromJson(data);

    if (statusCode == 200) {
      var user = UserModel.fromJSON(apiResponse.data);

      await setValue(isLoggedInPref, true);
      await setValue(isDeviceVerifiedPref, false);
      await setValue(userIdPref, user.id);
      await setValue(firstNamePref, user.firstName);
      await setValue(lastNamePref, user.lastName);
      await setValue(genderPref, user.gender);
      if (!user.avatar.isEmptyOrNull) {
        await setValue(avatarPref, user.avatar ?? '');
      }

      await setValue(locationActivityTrackingEnabledPref,
          user.locationActivityTrackingEnabled);

      await setValue(employeeCodePref, user.employeeCode);

      await setValue(addressPref, user.address);
      await setValue(phoneNumberPref, user.phoneNumber);
      await setValue(alternateNumberPref, user.alternateNumber);
      await setValue(statusPref, user.status);
      await setValue(tokenPref, user.token);
      await setValue(emailPref, user.email);
      await setValue(designationPref, user.designation);
      await setValue(approverPref, user.isApprover);
      isLoading = false;
      return user.status.toString();
    } else {
      await setValue(isLoggedInPref, false);
      await setValue(isDeviceVerifiedPref, false);
      toast(apiResponse.data.toString());
      isLoading = false;
      return "";
    }
  }

  Future createDemoUser() async {
    isDemoRegisterBtnLoading = true;
    var result = await apiService.createDemoUser();
    if (result != null) {
      setValue('isDemoCreds', true);
      var user = result;
      await setValue(userIdPref, user.id);
      await setValue(isLoggedInPref, true);
      await setValue(isDeviceVerifiedPref, false);
      await setValue(firstNamePref, user.firstName);
      await setValue(lastNamePref, user.lastName);
      await setValue(genderPref, user.gender);
      if (!user.avatar.isEmptyOrNull) {
        await setValue(avatarPref, user.avatar ?? '');
      }

      await setValue(addressPref, user.address);
      await setValue(phoneNumberPref, user.phoneNumber);
      await setValue(alternateNumberPref, user.alternateNumber);
      await setValue(statusPref, user.status);
      await setValue(tokenPref, user.token);
      //await validateDevice();
      isLoginWithUidBtnLoading = false;
      return user.status.toString();
    } else {
      await setValue(isLoggedInPref, false);
      await setValue(isDeviceVerifiedPref, false);
      isLoginWithUidBtnLoading = false;
      return "";
    }
    isDemoRegisterBtnLoading = false;
  }

  Future<String> loginWithUid() async {
    isLoginWithUidBtnLoading = true;
    var deviceId = await sharedHelper.getDeviceId();
    if (deviceId.isEmptyOrNull) {
      log('Invalid device id');
      isLoginWithUidBtnLoading = false;
      return "";
    }
    var result = await apiService.loginWIthUid(deviceId!);
    if (result != null) {
      var user = result;
      await setValue(userIdPref, user.id);
      await setValue(isLoggedInPref, true);
      await setValue(isDeviceVerifiedPref, false);
      await setValue(firstNamePref, user.firstName);
      await setValue(lastNamePref, user.lastName);
      await setValue(genderPref, user.gender);
      if (!user.avatar.isEmptyOrNull) {
        await setValue(avatarPref, user.avatar ?? '');
      }

      await setValue(addressPref, user.address);
      await setValue(phoneNumberPref, user.phoneNumber);
      await setValue(alternateNumberPref, user.alternateNumber);
      await setValue(statusPref, user.status);
      await setValue(tokenPref, user.token);
      await setValue(approverPref, user.isApprover);
      //await validateDevice();
      isLoginWithUidBtnLoading = false;
      return user.status.toString();
    } else {
      await setValue(isLoggedInPref, false);
      await setValue(isDeviceVerifiedPref, false);
      isLoginWithUidBtnLoading = false;
      return "";
    }
  }
}

class LoginFormError = LoginFormErrorState with _$LoginFormError;

abstract class LoginFormErrorState with Store {
  @observable
  String? employeeId;

  @observable
  String? password;

  @computed
  bool get hasErrors => employeeId != null || password != null;
}
