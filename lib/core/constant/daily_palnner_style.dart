import 'package:flutter/material.dart';

class DailyPlannerStyle {
  static TextStyle appbarTitle() {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.0,
    );
  }

  static TextStyle labelText() {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1.0,
    );
  }

  static TextStyle fieldLabelText() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      letterSpacing: 1.0,
    );
  }

  static TextStyle hintText({Color? color}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? Colors.grey,
      letterSpacing: 1.0,
    );
  }

  static TextStyle buttonText() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
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
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpace,
      color: color ?? Colors.black,
    );
  }
}
