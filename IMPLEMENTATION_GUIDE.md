# LA3IB Implementation Guide

## 📋 Overview

This guide covers implementing the security fixes, brand identity, and modern UI redesign for LA3IB.

---

## 🔒 Part 1: Critical Security Fixes

### 1.1 Environment Configuration

**Create `.env` file in project root:**
```env
GOOGLE_CLIENT_ID=903668742117-vrmce023vnpkgutltplr05nosc1ea3sp.apps.googleusercontent.com
```

**Update `.gitignore`:**
```gitignore
# Environment
.env
.env.local
.env.*.local
```

**Build with environment:**
```bash
# Development
flutter run -d chrome --dart-define=GOOGLE_CLIENT_ID=your_client_id

# Production
flutter build web --dart-define=GOOGLE_CLIENT_ID=your_client_id
```

### 1.2 Deploy Firestore Rules

**Command:**
```bash
firebase deploy --only firestore:rules
```

**Verify:**
- Go to Firebase Console
- Navigate to Firestore Database → Rules
- Confirm rules are deployed

### 1.3 Deploy Firestore Indexes

**Command:**
```bash
firebase deploy --only firestore:indexes
```

**Note:** Indexes may take 5-15 minutes to build

---

## 🎨 Part 2: Brand Implementation

### 2.1 File Structure

Create the following directory structure:

```
lib/src/
├── theme/
│   ├── brand_colors.dart
│   ├── brand_typography.dart
│   ├── brand_theme.dart
│   └── theme_provider.dart (optional - for theme switching)
├── config/
│   └── env_config.dart
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── auth_repository.dart (updated)
│   │   │   └── firestore_service.dart
│   │   ├── domain/
│   │   │   └── app_user.dart
│   │   └── presentation/
│   │       ├── sign_in_screen.dart (new modern version)
│   │       ├── onboarding_screen.dart
│   │       ├── sign_in_controller.dart
│   │       └── user_profile_provider.dart (new)
│   └── games/
│       ├── data/
│       │   └── game_repository.dart (new)
│       ├── domain/
│       │   ├── game.dart (new)
│       │   └── participant.dart (new)
│       └── presentation/
│           └── (to be created in Phase 2)
```

### 2.2 Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^13.2.5
  google_fonts: ^6.3.3
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^6.1.2
  google_sign_in: ^6.3.0
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

dev_dependencies:
  # Existing dev dependencies
  build_runner: ^2.5.4
  riverpod_generator: ^2.6.5
  freezed: ^3.1.0
  json_serializable: ^6.9.5
  flutter_lints: ^3.0.2
```

### 2.3 Run Code Generation

```bash
# Generate all Riverpod and Freezed files
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🖼️ Part 3: UI Implementation

### 3.1 Update App Theme

**Replace `lib/src/app.dart`:**

```dart
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
```

### 3.2 Modern Component Library

Create reusable components in `lib/src/common_widgets/`:

**sport_badge.dart:**
```dart
import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_typography.dart';

class SportBadge extends StatelessWidget {
  const SportBadge({
    super.key,
    required this.sport,
    this.size = SportBadgeSize.medium,
  });

  final String sport;
  final SportBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final color = BrandColors.getSportColor(sport);
    final iconSize = size == SportBadgeSize.small ? 16.0 : 24.0;
    final fontSize = size == SportBadgeSize.small ? 10.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == SportBadgeSize.small ? 8 : 12,
        vertical: size == SportBadgeSize.small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getSportIcon(sport), size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            sport,
            style: BrandTypography.labelSmall(color: color).copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'padel':
      case 'tennis':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }
}

enum SportBadgeSize { small, medium }
```

**status_badge.dart:**
```dart
import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_typography.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = BrandColors.getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: BrandTypography.labelSmall(color: color).copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
```

---

## 📱 Part 4: Screen Redesigns

### 4.1 Sign-In Screen

Use the `ModernSignInScreen` provided - it includes:
- ✅ Animated gradient background
- ✅ Modern card-based layout
- ✅ Password strength indicator
- ✅ Google Sign-In prominence
- ✅ Smooth animations

### 4.2 Onboarding Screen (To Redesign)

Key improvements needed:
- Use chip selection instead of checkboxes for sports
- Add visual sport icons
- Progress indicator (Step 1 of 3)
- Gradient header
- Better spacing and animations

### 4.3 Home Screen (To Create)

Should include:
- Search bar with filters
- Game cards grid/list
- Quick stats (games played, upcoming)
- FAB for creating games
- Modern navigation

---

## 🚀 Part 5: Deployment Checklist

### Pre-Deploy

- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all pass
- [ ] Generate all code: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Update Firebase security rules
- [ ] Deploy Firestore indexes
- [ ] Set environment variables

### Deploy to Firebase Hosting

```bash
# Build
flutter build web --dart-define=GOOGLE_CLIENT_ID=your_client_id

# Deploy
firebase deploy --only hosting
```

### Post-Deploy

- [ ] Test authentication flow
- [ ] Verify Firestore permissions
- [ ] Check responsive design (mobile, tablet, desktop)
- [ ] Test in different browsers (Chrome, Safari, Firefox)
- [ ] Verify RTL support for Arabic

---

## 🎯 Next Steps (Phase 2)

### Week 3-4: Game Creation & Discovery

1. **Create Game Screen**
   - Modern form with validation
   - Date/time picker
   - Location input (text only for MVP)
   - Price input with SAR display

2. **Game Card Component**
   - Image header with gradient overlay
   - Sport badge
   - Status badge
   - Slots remaining indicator
   - Join button

3. **Home/Discovery Screen**
   - Search & filter
   - Game cards list
   - Pull to refresh
   - Empty state illustration

### Week 5: Join Flow

1. **Game Details Screen**
   - Full game information
   - Participant list
   - Join/Leave button
   - Share functionality

2. **My Games Screen**
   - Tabs: Organized | Joined
   - Upcoming vs Past
   - Quick actions

---

## 📚 Resources

### Design System
- See `BRAND_IDENTITY.md` for complete brand guidelines
- Use Figma/Adobe XD to create high-fidelity mockups

### Testing
- Test with real Saudi phone numbers for auth
- Use Firebase Emulator for local testing

### Performance
- Enable tree-shaking for web build
- Optimize images (use WebP format)
- Lazy-load screens

---

## 🐛 Common Issues & Solutions

### Issue: Google Sign-In not working on Web

**Solution:**
1. Verify `GOOGLE_CLIENT_ID` is set correctly
2. Check Firebase Console → Authentication → Google → Web SDK
3. Ensure authorized domains include `localhost` and your production domain

### Issue: Firestore permission denied

**Solution:**
1. Check Firestore rules are deployed
2. Verify user is authenticated
3. Check document path matches rules

### Issue: Build runner fails

**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 💡 Tips for Success

1. **Commit Often**: Commit after each working feature
2. **Test on Real Devices**: Use Firebase App Distribution for beta testing
3. **Monitor Performance**: Use Firebase Performance Monitoring
4. **User Feedback**: Add in-app feedback form early
5. **Analytics**: Implement Firebase Analytics from day one

---

## 📞 Support

- Firebase Issues: https://firebase.google.com/support
- Flutter Issues: https://flutter.dev/community
- LA3IB specific: [Your support channel]

---

**Last Updated:** February 2026
**Version:** 1.0.0 (MVP Foundation)
