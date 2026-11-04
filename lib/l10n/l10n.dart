import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// The app's text in the current language (English or Bangla).
///
/// `CalAiApp` keeps it in step with the language in use, so widgets,
/// labels on models and notification texts can all read it without a
/// `BuildContext`. Until then (and in plain unit tests) it is English.
AppLocalizations get l10n => _current;

AppLocalizations _current = lookupAppLocalizations(const Locale('en'));

/// Called by `CalAiApp` when the language is known or changes.
void useLocalizations(AppLocalizations strings) => _current = strings;
