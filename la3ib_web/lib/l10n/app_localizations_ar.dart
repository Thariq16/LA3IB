// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لاعب';

  @override
  String get homeTitle => 'لاعب الرئيسية';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get signInGoogle => 'تسجيل الدخول عبر جوجل';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get emailRequired => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get passwordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get signInButton => 'دخول';

  @override
  String get onboardingTitle => 'إعداد الملف الشخصي';

  @override
  String get nameLabel => 'الاسم المعروض';

  @override
  String get nameRequired => 'يرجى إدخال اسمك';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get cityRequired => 'يرجى اختيار مدينتك';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get sportsLabel => 'الرياضات المفضلة (حد أقصى 2)';

  @override
  String get sportsRequired => 'يرجى اختيار رياضة واحدة على الأقل';

  @override
  String get sportsMaxError => 'يمكنك اختيار رياضتين كحد أقصى';

  @override
  String get completeButton => 'إكمال الإعداد';
}
