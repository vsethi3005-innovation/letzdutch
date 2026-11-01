import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letz_core/letz_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';

/// Phone number sign-in with a one-time SMS code (Supabase Auth).
///
/// The router sends the user on once a session exists, so this screen
/// never navigates itself.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  String? _sentTo;
  String? _error;
  bool _busy = false;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final t = AppLocalizations.of(context);
    final phone = normalizeUaeMobile(_phone.text);
    if (phone == null) {
      setState(() => _error = t.invalidPhone);
      return;
    }
    await _run(() async {
      await _auth.signInWithOtp(phone: phone);
      _sentTo = phone;
    });
  }

  Future<void> _verify() async {
    await _run(
      () => _auth.verifyOTP(
        type: OtpType.sms,
        phone: _sentTo!,
        token: _code.text.trim(),
      ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final codeStep = _sentTo != null;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            Icon(
              Icons.restaurant,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(t.signInTitle, style: text.headlineMedium),
            const SizedBox(height: 8),
            Text(
              codeStep ? t.enterCode(_sentTo!) : t.signInSubtitle,
              style: text.bodyLarge,
            ),
            const SizedBox(height: 32),
            if (!codeStep)
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: t.phoneNumber,
                  prefixText: '+971 ',
                  hintText: '50 123 4567',
                ),
                onSubmitted: (_) => _sendCode(),
              )
            else
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                textDirection: TextDirection.ltr,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
                style: text.headlineSmall?.copyWith(letterSpacing: 8),
                onSubmitted: (_) => _verify(),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : (codeStep ? _verify : _sendCode),
              child: _busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(codeStep ? t.verify : t.sendCode),
            ),
            if (codeStep)
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() {
                        _sentTo = null;
                        _code.clear();
                        _error = null;
                      }),
                child: Text(t.changeNumber),
              ),
          ],
        ),
      ),
    );
  }
}
