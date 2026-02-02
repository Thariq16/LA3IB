import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import '../../../common_widgets/primary_button.dart';
import '../../../common_widgets/responsive_center.dart';
import '../../../constants/app_sizes.dart';
import '../../../utils/error_message_util.dart';
import 'sign_in_controller.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // New controller
  final _formKey = GlobalKey<FormState>();

  var _formType = _EmailPasswordSignInFormType.signIn;
  var _obscurePassword = true;  // New state
  var _obscureConfirmPassword = true; // New state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _formTypeToggle() {
    setState(() {
      _formType = _formType == _EmailPasswordSignInFormType.signIn
          ? _EmailPasswordSignInFormType.register
          : _EmailPasswordSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(signInControllerProvider.notifier);
      if (_formType == _EmailPasswordSignInFormType.signIn) {
        await controller.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await controller.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... existing variable definitions ...
    final state = ref.watch(signInControllerProvider);
    final loc = AppLocalizations.of(context)!;
    
    // ... Ref Listen Code ...

    final primaryText = _formType == _EmailPasswordSignInFormType.signIn
        ? loc.signInButton
        : 'Create Account'; // TODO: add to l10n
    final secondaryText = _formType == _EmailPasswordSignInFormType.signIn
        ? 'Need an account? Register' // TODO: add to l10n
        : 'Have an account? Sign In'; // TODO: add to l10n

    return Scaffold(
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ... Title and Email Field ...
              Text(
                loc.appTitle,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              gapH32,
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: loc.emailLabel,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                   if (value == null || value.isEmpty) {
                    return loc.emailRequired;
                   }
                   if (!value.contains('@') || !value.contains('.')) {
                     return 'Please enter a valid email';
                   }
                   return null;
                },
              ),
              gapH16,
              // Password Field with onChanged to rebuild UI
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (value) => setState(() {}), // Rebuild to update strength indicator
                decoration: InputDecoration(
                  labelText: loc.passwordLabel,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.passwordRequired;
                  }
                  if (_formType == _EmailPasswordSignInFormType.register) {
                    if (value.length < 8) return ' '; // Return space to show error state but not text (handled by visual indicator)
                    if (!value.contains(RegExp(r'[A-Z]'))) return ' ';
                    if (!value.contains(RegExp(r'[a-z]'))) return ' ';
                    if (!value.contains(RegExp(r'[0-9]'))) return ' ';
                    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return ' ';
                  }
                  return null;
                },
              ),
              
              // Strength Indicator
              if (_formType == _EmailPasswordSignInFormType.register)
                _PasswordStrengthIndicator(password: _passwordController.text),

              if (_formType == _EmailPasswordSignInFormType.register) ...[
                gapH16,
                TextFormField(
                  controller: _confirmPasswordController,
                  // ... Confirm Password Props ...
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                     suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
              gapH24,
              PrimaryButton(
                text: primaryText,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
              gapH16,
              TextButton(
                onPressed: state.isLoading ? null : _formTypeToggle,
                child: Text(secondaryText),
              ),
              const Divider(),
              gapH16,
              OutlinedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => ref
                        .read(signInControllerProvider.notifier)
                        .signInWithGoogle(),
                icon: const Icon(Icons.g_mobiledata, size: 32),
                label: Text(loc.signInGoogle),
                style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 12),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return Column(
      children: [
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _RequirementDot(met: hasMinLength, label: '8+ Chars'),
            _RequirementDot(met: hasUppercase, label: 'Upper'),
            _RequirementDot(met: hasLowercase, label: 'Lower'),
            _RequirementDot(met: hasDigits, label: 'Digit'),
            _RequirementDot(met: hasSpecial, label: 'Symbol'),
          ],
        ),
      ],
    );
  }
}

class _RequirementDot extends StatelessWidget {
  const _RequirementDot({required this.met, required this.label});
  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          color: met ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: met ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}

enum _EmailPasswordSignInFormType { signIn, register }
