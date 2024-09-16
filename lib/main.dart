import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final _colorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 122, 5));

final _theme = ThemeData().copyWith(
  scaffoldBackgroundColor: _colorScheme.onPrimary,
  colorScheme: _colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      home: const Tabs(),
    );
  }
}
