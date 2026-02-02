import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import '../../authentication/data/auth_repository.dart';
import '../../../common_widgets/primary_button.dart';
import '../../../common_widgets/responsive_center.dart';
import '../../../constants/app_sizes.dart';
import '../../../utils/error_message_util.dart';
import 'onboarding_controller.dart';
import 'user_profile_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String? _selectedCity;
  String _selectedGender = 'Male';
  final List<String> _selectedSports = [];

  // TODO: Move these to a constant or fetch from backend
  final List<String> _cities = ['Riyadh', 'Jeddah', 'Dammam', 'Khobar', 'Mecca', 'Medina'];
  final List<String> _sports = ['Football', 'Basketball', 'Padel', 'Volleyball', 'Tennis'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print('DEBUG: _submit called inside OnboardingScreen');
    if (_formKey.currentState!.validate()) {
       final loc = AppLocalizations.of(context)!;
      if (_selectedSports.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.sportsRequired)),
        );
        return;
      }
      
      print('DEBUG: Calling completeOnboarding');
      await ref.read(onboardingControllerProvider.notifier).completeOnboarding(
        displayName: _nameController.text,
        city: _selectedCity!,
        gender: _selectedGender,
        preferredSports: _selectedSports,
      );
    } else {
      print('DEBUG: Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final loc = AppLocalizations.of(context)!;

    ref.listen<AsyncValue>(onboardingControllerProvider, (previous, state) {
      if (state.hasError) {
        print('DEBUG: Onboarding Error: ${state.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorMessageUtil.getErrorMessage(state.error),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else if (!state.isLoading && previous?.isLoading == true && !state.hasError) {
         print('DEBUG: Onboarding Success - navigating to home');
         // Invalidate user profile to trigger refresh
         ref.invalidate(currentUserProfileProvider);
         // Navigate to home
         if (context.mounted) {
           context.go('/');
         }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(loc.onboardingTitle)),
      body: ResponsiveCenter(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: loc.nameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.nameRequired;
                    }
                    return null;
                  },
                ),
                gapH24,
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: InputDecoration(
                    labelText: loc.cityLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCity = value),
                  validator: (value) =>
                      value == null ? loc.cityRequired : null,
                ),
                gapH24,
                Text(loc.genderLabel, style: Theme.of(context).textTheme.titleMedium),
                gapH8,
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'Male', label: Text(loc.genderMale)),
                    ButtonSegment(value: 'Female', label: Text(loc.genderFemale)),
                  ],
                  selected: {_selectedGender},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedGender = newSelection.first;
                    });
                  },
                ),
                gapH24,
                Text(loc.sportsLabel, style: Theme.of(context).textTheme.titleMedium),
                gapH8,
                Wrap(
                  spacing: 8.0,
                  children: _sports.map((sport) {
                    final isSelected = _selectedSports.contains(sport);
                    return FilterChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            if (_selectedSports.length < 2) {
                              _selectedSports.add(sport);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.sportsMaxError)),
                              );
                            }
                          } else {
                            _selectedSports.remove(sport);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                gapH32,
                PrimaryButton(
                  text: loc.completeButton,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
