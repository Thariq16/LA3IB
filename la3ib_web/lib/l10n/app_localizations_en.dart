// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LA3IB';

  @override
  String get homeTitle => 'LA3IB Home';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signInGoogle => 'Sign in with Google';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get onboardingTitle => 'Setup Profile';

  @override
  String get nameLabel => 'Display Name';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get cityLabel => 'City';

  @override
  String get cityRequired => 'Please select your city';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get sportsLabel => 'Preferred Sports (Max 2)';

  @override
  String get sportsRequired => 'Please select at least 1 sport';

  @override
  String get sportsMaxError => 'You can only select up to 2 sports';

  @override
  String get completeButton => 'Complete Setup';
}
