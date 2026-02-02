import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    // Default to English
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;
    state = locale;
  }

  void toggleLocale() {
    state = state.languageCode == 'en' ? const Locale('ar') : const Locale('en');
  }
}
