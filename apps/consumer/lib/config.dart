/// Build-time configuration, passed with `--dart-define-from-file`.
///
/// ```
/// flutter run --dart-define-from-file=env/dev.json
/// ```
/// Without it the app runs on built-in demo data with no sign-in.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Launch market: Dubai.
  static const currency = 'AED';
}
