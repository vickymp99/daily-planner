import 'package:flutter/material.dart';

class DailyPlannerStyle {
  static TextStyle appbarTitle() {
    return TextStyle().copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.0,
    );
  }

  static TextStyle labelText() {
    return TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );
  }

  static TextStyle fieldLabelText() {
    return TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    );
  }

  static TextStyle hintText({Color? color}) {
    return TextStyle().copyWith(fontSize: 14, letterSpacing: 1.0);
  }

  static TextStyle buttonText() {
    return TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    );
  }

  static TextStyle normalText({
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
    double? letterSpace,
    Color? color,
  }) {
    return TextStyle().copyWith(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpace,
    );
  }


  static TextStyle cardTitle() {
    return TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
    );
  }

  static TextStyle cardDesc() {
    return TextStyle().copyWith(
      fontSize: 16,
    );
  }
}
