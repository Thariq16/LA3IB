import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la3ib_web/l10n/app_localizations.dart';
import '../../../constants/app_sizes.dart';
import '../../../theme/brand_colors.dart';
import '../../../theme/brand_typography.dart';
import '../../../theme/brand_theme.dart';
import '../../../utils/error_message_util.dart';
import 'sign_in_controller.dart';

class ModernSignInScreen extends ConsumerStatefulWidget {
  const ModernSignInScreen({super.key});

  @override
  ConsumerState<ModernSignInScreen> createState() => _ModernSignInScreenState();
}

class _ModernSignInScreenState extends ConsumerState<ModernSignInScreen> 
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _formType = _EmailPasswordSignInFormType.signIn;
  var _obscurePassword = true;
  var _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    final state = ref.watch(signInControllerProvider);
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    ref.listen<AsyncValue>(signInControllerProvider, (_, state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorMessageUtil.getErrorMessage(state.error)),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: BrandColors.heroGradient,
            ),
          ),
          
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? AppSizes.p24 : AppSizes.p48),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildContent(context, loc, state, isMobile),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations loc,
    AsyncValue state,
    bool isMobile,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 450),
      child: Container(
        padding: EdgeInsets.all(isMobile ? AppSizes.p24 : AppSizes.p32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BrandTheme.radiusXXLarge,
          boxShadow: BrandTheme.shadowXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo & Title
            _buildHeader(context, loc),
            gapH32,
            
            // Google Sign-In (Prominent)
            _buildGoogleButton(context, loc, state),
            gapH24,
            
            // Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: BrandTypography.labelMedium(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            gapH24,
            
            // Email/Password Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmailField(context, loc),
                  gapH16,
                  _buildPasswordField(context, loc),
                  if (_formType == _EmailPasswordSignInFormType.register) ...[
                    gapH8,
                    _PasswordStrengthIndicator(password: _passwordController.text),
                    gapH16,
                    _buildConfirmPasswordField(context, loc),
                  ],
                  gapH24,
                  _buildSubmitButton(context, loc, state),
                  gapH16,
                  _buildToggleButton(context, loc, state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: BrandTheme.shadowMd,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/app_icon.png',
            fit: BoxFit.cover,
          ),
        ),
        gapH16,
        
        // Brand name
        ShaderMask(
          shaderCallback: (bounds) => BrandColors.primaryGradient.createShader(bounds),
          child: Text(
            loc.appTitle,
            style: BrandTypography.displayLarge(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        gapH8,
        
        Text(
          _formType == _EmailPasswordSignInFormType.signIn
              ? 'Welcome back!'
              : 'Create your account',
          style: BrandTypography.bodyLarge(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoogleButton(
    BuildContext context,
    AppLocalizations loc,
    AsyncValue state,
  ) {
    return FilledButton.icon(
      onPressed: state.isLoading
          ? null
          : () => ref.read(signInControllerProvider.notifier).signInWithGoogle(),
      icon: const Icon(Icons.g_mobiledata, size: 32),
      label: Text(loc.signInGoogle),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.lightTextPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        side: const BorderSide(color: BrandColors.lightBorder),
        textStyle: BrandTypography.buttonLarge(),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, AppLocalizations loc) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: loc.emailLabel,
        hintText: 'you@example.com',
        prefixIcon: const Icon(Icons.email_outlined),
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
    );
  }

  Widget _buildPasswordField(BuildContext context, AppLocalizations loc) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: loc.passwordLabel,
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return loc.passwordRequired;
        }
        if (_formType == _EmailPasswordSignInFormType.register) {
          if (value.length < 8) return ' ';
          if (!value.contains(RegExp(r'[A-Z]'))) return ' ';
          if (!value.contains(RegExp(r'[a-z]'))) return ' ';
          if (!value.contains(RegExp(r'[0-9]'))) return ' ';
          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return ' ';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, AppLocalizations loc) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
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
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    AppLocalizations loc,
    AsyncValue state,
  ) {
    final isSignIn = _formType == _EmailPasswordSignInFormType.signIn;
    
    return FilledButton(
      onPressed: state.isLoading ? null : _submit,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: state.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(isSignIn ? loc.signInButton : 'Create Account'),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    AppLocalizations loc,
    AsyncValue state,
  ) {
    final isSignIn = _formType == _EmailPasswordSignInFormType.signIn;
    
    return TextButton(
      onPressed: state.isLoading ? null : _formTypeToggle,
      child: RichText(
        text: TextSpan(
          style: BrandTypography.bodyMedium(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          children: [
            TextSpan(
              text: isSignIn
                  ? "Don't have an account? "
                  : "Already have an account? ",
            ),
            TextSpan(
              text: isSignIn ? 'Sign Up' : 'Sign In',
              style: BrandTypography.bodyMedium(color: BrandColors.primaryGreen)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
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

    final requirements = [
      _Requirement(met: hasMinLength, label: '8+ chars'),
      _Requirement(met: hasUppercase, label: 'A-Z'),
      _Requirement(met: hasLowercase, label: 'a-z'),
      _Requirement(met: hasDigits, label: '0-9'),
      _Requirement(met: hasSpecial, label: '!@#\$'),
    ];

    final metCount = requirements.where((r) => r.met).length;
    final strength = metCount / requirements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength,
            minHeight: 6,
            backgroundColor: BrandColors.lightBorder,
            valueColor: AlwaysStoppedAnimation(
              strength < 0.4
                  ? BrandColors.error
                  : strength < 0.7
                      ? BrandColors.warningYellow
                      : BrandColors.success,
            ),
          ),
        ),
        gapH8,
        
        // Requirements
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: requirements
              .map((req) => _RequirementChip(requirement: req))
              .toList(),
        ),
      ],
    );
  }
}

class _Requirement {
  final bool met;
  final String label;
  const _Requirement({required this.met, required this.label});
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.requirement});
  final _Requirement requirement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: requirement.met
            ? BrandColors.success.withValues(alpha: 0.1)
            : BrandColors.lightSurfaceDim,
        borderRadius: BrandTheme.radiusSmall,
        border: Border.all(
          color: requirement.met ? BrandColors.success : BrandColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            requirement.met ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: requirement.met ? BrandColors.success : BrandColors.lightTextDisabled,
          ),
          const SizedBox(width: 4),
          Text(
            requirement.label,
            style: BrandTypography.labelSmall(
              color: requirement.met ? BrandColors.success : BrandColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

enum _EmailPasswordSignInFormType { signIn, register }
