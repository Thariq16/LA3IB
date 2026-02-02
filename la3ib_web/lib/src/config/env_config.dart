/// Environment configuration class
/// Loads configuration from environment variables
class EnvConfig {
  EnvConfig._();

  /// Google OAuth Client ID for web sign-in
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );
}
