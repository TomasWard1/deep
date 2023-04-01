import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFont extends StatelessWidget {
  final inputText, fontSize, fontType;
  final fontWeight;

  CustomFont({this.inputText, this.fontSize, this.fontType, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      inputText,
      style: TextStyle(
        fontFamily: fontType,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
