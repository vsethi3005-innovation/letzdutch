/// Build-time configuration, passed with `--dart-define`.
///
/// ```
/// flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///             --dart-define=SUPABASE_ANON_KEY=...
/// ```
/// Without them the app runs on built-in demo data.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Launch market: Dubai.
  static const currency = 'AED';
}
