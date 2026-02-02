import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import '../../authentication/data/auth_repository.dart';
import '../../../common_widgets/responsive_center.dart';
import '../../../constants/app_sizes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LA3IB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.pushNamed('profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        child: Center(
          child: Text('Welcome to LA3IB!'),
        ),
      ),
    );
  }
}
