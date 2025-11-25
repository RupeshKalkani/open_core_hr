import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../models/payslip_model.dart';

part 'payslip_store.g.dart';

class PayslipStore = PayslipStoreBase with _$PayslipStore;

abstract class PayslipStoreBase with Store {
  @observable
  bool isLoading = false;

  List<PayslipModel> payslips = [];

  Future getPayslips() async {
    isLoading = true;
    payslips = await apiService.getPayslips();
    isLoading = false;
  }

  Future downloadPayslip(int payslipId) async {
    isLoading = true;
    var result = await apiService.downloadPayslip(payslipId);
    isLoading = false;
    _launchUrl(Uri.parse(result));
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');
    }
  }
}
