import 'package:flutter/material.dart';

ThemeData myAppTheme = buildTheme();

ThemeData buildTheme() {
  final ThemeData dark = ThemeData.dark();
  return dark.copyWith(
    textSelectionColor: Colors.grey,
    textTheme: dark.textTheme.copyWith(
      body1: dark.textTheme.body1.copyWith(
        fontSize: 16
      ),
      body2: dark.textTheme.body2.copyWith(
        fontSize: 18
      ),
    )
  );
}