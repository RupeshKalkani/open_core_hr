import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:validators/validators.dart';

import '../../main.dart';

part 'ForgotPasswordStore.g.dart';

class ForgotPasswordStore = ForgotPasswordStoreBase with _$ForgotPasswordStore;

abstract class ForgotPasswordStoreBase with Store {
  @observable
  Status status = Status.start;

  @observable
  bool isLoading = false;

  @observable
  String? errorMsg;

  @observable
  String? phoneNumber;

  @observable
  String? otp;

  @action
  Future sendOTPToPhone() async {
    isLoading = true;

    if (phoneNumber!.length > 9) {
      var result = await apiService.forgotPassword(phoneNumber!);

      if (!result) {
        status = Status.start;
        toast(language.lblUnableToSendAnOTPTryAgainLater);
      } else {
        status = Status.otp;
      }
    }
    isLoading = false;
  }

  @action
  Future verifyOTP() async {
    isLoading = true;

    if (otp.isEmptyOrNull) {
      toast(language.lblOtpIsRequired);
    }

    if (otp!.length == 4) {
      var result = await apiService.verifyOTP(phoneNumber!, otp!);
      if (!result) {
        status = Status.otp;
        toast(language.lblWrongOTP);
      } else {
        status = Status.verified;
      }
    }

    isLoading = false;
  }

  @action
  Future<bool> resetPassword(String password) async {
    isLoading = true;

    Map req = {"phoneNumber": phoneNumber, "password": password};

    var result = await apiService.resetPassword(req);
    if (!result) {
      toast(language.lblUnableToChangeThePassword);
    } else {
      return true;
    }

    isLoading = false;
    return false;
  }

  void setupValidators() {
    reaction((_) => phoneNumber, validatePhoneNumber);
  }

  Future validatePhoneNumber(String? value) async {
    if (isNull(value) || value == '') {
      errorMsg = language.lblCannotBeBlank;
      return;
    }

    if (value!.length > 9) {
      try {
        var phoneNumberCheck =
            ObservableFuture(apiService.checkValidPhoneNumber(value));
        final isValid = await phoneNumberCheck;
        if (!isValid) {
          errorMsg = language.lblPhoneNumberDoesNotExists;
          return;
        }
        errorMsg = null;
      } on Object catch (_) {
        errorMsg = null;
        return;
      }
    }

    errorMsg = null;
    return;
  }
}

enum Status { start, otp, verified, done }
