import 'package:flutter/widgets.dart';

class S {
  static const Map<String, Map<String, String>> _strings = {
    'ar': {
      'title': 'مدرستي', 'year': 'السنة', 'solve': 'احسب',
      'ok': 'أحسنت!', 'ko': 'حاول مرة أخرى',
      'math': 'الرياضيات', 'reading': 'القراءة',
      'french': 'الفرنسية', 'english': 'الإنجليزية',
    },
    'fr': {
      'title': 'Mon école', 'year': 'Année', 'solve': 'Calcule',
      'ok': 'Bravo !', 'ko': 'Essaie encore',
      'math': 'Maths', 'reading': 'Lecture',
      'french': 'Français', 'english': 'Anglais',
    },
    'en': {
      'title': 'My school', 'year': 'Year', 'solve': 'Solve',
      'ok': 'Well done!', 'ko': 'Try again',
      'math': 'Maths', 'reading': 'Reading',
      'french': 'French', 'english': 'English',
    },
  };

  static Map<String, String> of(BuildContext context) =>
      _strings[Localizations.localeOf(context).languageCode]!;
}
