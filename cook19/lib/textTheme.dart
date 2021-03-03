import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData bright = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple[800],
  accentColor: Colors.teal[600],
  textTheme: GoogleFonts.solwayTextTheme(),
);

ThemeData dark = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  accentColor: Colors.deepOrange[500],
  textTheme: GoogleFonts.inconsolataTextTheme(
    TextTheme(
      // ignore: deprecated_member_use
      body1: TextStyle(color: Colors.white),
    ),
  ),
);

