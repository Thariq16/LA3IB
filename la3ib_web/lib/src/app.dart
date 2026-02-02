import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'localization/locale_provider.dart';

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
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A651), // KSA Green-ish
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
