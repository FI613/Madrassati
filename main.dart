import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n.dart';

void main() => runApp(const MadrasatiApp());

const subjects = [
  (Icons.calculate, 'math'),
  (Icons.menu_book, 'reading'),
  (Icons.translate, 'french'),
  (Icons.abc, 'english'),
];

class MadrasatiApp extends StatefulWidget {
  const MadrasatiApp({super.key});

  @override
  State<MadrasatiApp> createState() => _MadrasatiAppState();
}

class _MadrasatiAppState extends State<MadrasatiApp> {
  Locale _locale = const Locale('ar');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ar'), Locale('fr'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        textTheme: GoogleFonts.cairoTextTheme().apply(fontSizeFactor: 1.2),
      ),
      home: HomeScreen(onLocale: (l) => setState(() => _locale = l)),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<Locale> onLocale;
  const HomeScreen({super.key, required this.onLocale});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _grade = 1;
  int _stars = 0;

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(t['title']!),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              const Icon(Icons.star, color: Colors.amber),
              Text(' $_stars'),
            ]),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'ar', label: Text('عربي')),
              ButtonSegment(value: 'fr', label: Text('Français')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {lang},
            onSelectionChanged: (s) => widget.onLocale(Locale(s.first)),
          ),
          const SizedBox(height: 16),
          Text(t['year']!),
          Wrap(spacing: 8, children: [
            for (var g = 1; g <= 6; g++)
              ChoiceChip(
                label: Text('$g'),
                selected: g == _grade,
                onSelected: (_) => setState(() => _grade = g),
              ),
          ]),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              for (final s in subjects)
                Card(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(s.$1, size: 36), Text(t[s.$2]!)],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          QuizCard(
            key: ValueKey(_grade),
            grade: _grade,
            onCorrect: () => setState(() => _stars++),
          ),
        ],
      ),
    );
  }
}

class QuizCard extends StatefulWidget {
  final int grade;
  final VoidCallback onCorrect;
  const QuizCard({super.key, required this.grade, required this.onCorrect});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  final _rnd = Random();
  late int _a, _b;
  late List<int> _options;
  String? _feedback;
  bool _ok = false;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    final max = widget.grade * 5;
    _a = _rnd.nextInt(max) + 1;
    _b = _rnd.nextInt(max) + 1;
    final ans = _a + _b;
    final opts = {ans};
    while (opts.length < 4) {
      final v = ans + _rnd.nextInt(7) - 3;
      if (v > 0) opts.add(v);
    }
    _options = opts.toList()..shuffle(_rnd);
    _feedback = null;
    _ok = false;
  }

  void _check(int v) {
    if (_ok) return;
    final t = S.of(context);
    if (v == _a + _b) {
      widget.onCorrect();
      setState(() {
        _ok = true;
        _feedback = t['ok'];
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(_next);
      });
    } else {
      setState(() => _feedback = t['ko']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(t['solve']!),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text('$_a + $_b = ?',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: [
              for (final o in _options)
                FilledButton.tonal(
                  onPressed: () => _check(o),
                  child: Text('$o', style: const TextStyle(fontSize: 28)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_feedback != null)
            Text(_feedback!,
                style: TextStyle(fontSize: 20, color: _ok ? Colors.green : Colors.red)),
        ]),
      ),
    );
  }
}
