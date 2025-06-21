import 'package:flutter/material.dart';

// Define your application's theme data
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green, // Setting the primary color to green
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green), // Define color scheme
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14.0),
  ),
  // Define other theme properties like button themes, card themes, etc.
);