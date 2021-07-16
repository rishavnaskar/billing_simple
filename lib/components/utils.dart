import 'package:flutter/material.dart';

class Utils {
  final Color kGrey = Color(0xff3C4042);
  final Color kBlack = Color(0xff202124);
  final Color kPink = Color(0xffEA80FC);

  final TextStyle kTextStyle = TextStyle(
    fontFamily: "Montserrat",
    color: Color(0xffEA80FC),
  );

  Widget kCircularProgressIndicator = Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEA80FC)),
    ),
  );

  Widget kErrorWidget = Center(
    child: Icon(Icons.error, color: Color(0xffEA80FC), size: 24),
  );

  Widget kSnackBar(String text) =>
      SnackBar(content: Text(text, style: kTextStyle), backgroundColor: kGrey);
}

final Utils utils = Utils();
