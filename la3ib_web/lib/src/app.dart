import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'localization/locale_provider.dart';
import 'theme/brand_theme.dart';

class La3ibApp extends ConsumerWidget {
  const La3ibApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final currentLocale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'LA3IB',
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      theme: BrandTheme.lightTheme(),
      darkTheme: BrandTheme.darkTheme(),
      themeMode: ThemeMode.system, // Or use a provider for user preference
    );
  }
}