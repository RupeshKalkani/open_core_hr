import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/locale/language_id.dart';

import 'language_ar.dart';
import 'language_bn.dart';
import 'language_de.dart';
import 'language_en.dart';
import 'language_es.dart';
import 'language_fr.dart';
import 'language_hi.dart';
import 'language_it.dart';
import 'language_ja.dart';
import 'language_ko.dart';
import 'language_pt.dart';
import 'language_ru.dart';
import 'language_ta.dart';
import 'language_te.dart';
import 'language_th.dart';
import 'language_tr.dart';
import 'language_vi.dart';
import 'languages.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'fr':
        return LanguageFr();
      case 'hi':
        return LanguageHi();
      case 'ta':
        return LanguageTa();
      case 'bn':
        return LanguageBn();
      case 'es':
        return LanguageEs();
      case 'ru':
        return LanguageRu();
      case 'de':
        return LanguageDe();
      case 'it':
        return LanguageIt();
      case 'id':
        return LanguageId();
      case 'th':
        return LanguageTh();
      case 'pt':
        return LanguagePt();
      case 'ja':
        return LanguageJa();
      case 'tr':
        return LanguageTr();
      case 'te':
        return LanguageTe();
      case 'vi':
        return LanguageVi();
      case 'ko':
        return LanguageKo();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) =>
      LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
