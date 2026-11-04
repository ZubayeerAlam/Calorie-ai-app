import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../food_log/presentation/widgets/detail_field.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../data/sync_service.dart';
import '../../providers/account_provider.dart';
import '../../../../l10n/l10n.dart';

/// Sign in, or create an account, with email and password. Optional: it
/// backs the data up and syncs it between phones.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _creating = false;

  /// Opened from Account (go back there) or from onboarding (go Home, or
  /// on with onboarding when the account has no profile yet).
  late final bool _fromAccount;

  @override
  void initState() {
    super.initState();
    _fromAccount = context.read<ProfileProvider>().isOnboarded;
  }

  bool _showPassword = false;
  String? _error;

  bool get _canSubmit =>
      _email.text.trim().contains('@') && _password.text.length >= 6;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final account = context.read<AccountProvider>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _error = null);
    try {
      if (_creating) {
        await account.createAccount(_email.text, _password.text);
      } else {
        await account.signIn(_email.text, _password.text);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.signedInAs(_email.text.trim()))),
      );
      if (_fromAccount) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } on SyncException {
      setState(() => _error = l10n.backupUnreachable);
    }
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      setState(() => _error = l10n.enterEmailFirst);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<AccountProvider>().sendPasswordReset(email);
      setState(() => _error = null);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.passwordResetSent(email))),
      );
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    }
  }

  void _toggleMode() => setState(() {
    _creating = !_creating;
    _error = null;
  });

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AccountProvider>().busy;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(
            _creating ? l10n.createAccount : l10n.signIn,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.signInIntro,
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const SizedBox(height: 24),
          DetailField(
            key: const ValueKey('email-field'),
            controller: _email,
            label: l10n.email,
            hint: l10n.emailHint,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('password-field'),
            controller: _password,
            obscureText: !_showPassword,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _canSubmit && !busy ? _submit() : null,
            decoration: InputDecoration(
              labelText: l10n.password,
              helperText: _creating ? l10n.passwordHelper : null,
              // Same look as the email field (DetailField).
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              suffixIcon: IconButton(
                tooltip: _showPassword ? l10n.hidePassword : l10n.showPassword,
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              key: const ValueKey('sign-in-error'),
              style: TextStyle(fontSize: 14, color: AppColors.badge),
            ),
          ],
          if (!_creating)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: busy ? null : _resetPassword,
                child: Text(l10n.forgotPassword),
              ),
            )
          else
            const SizedBox(height: 16),
          const SizedBox(height: 8),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              key: const ValueKey('submit-sign-in'),
              onPressed: _canSubmit && !busy ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.4,
                ),
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(
                      _creating ? l10n.createAccount : l10n.signIn,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              key: const ValueKey('toggle-sign-in-mode'),
              onPressed: busy ? null : _toggleMode,
              child: Text(
                _creating ? l10n.haveAccountSignIn : l10n.newHereCreateAccount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
