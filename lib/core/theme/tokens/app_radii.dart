import 'package:flutter/material.dart';

class AppRadii {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 20.0;
  static const double extraLarge = 28.0;
  static const double pill = 999.0;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(extraLarge);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}
