import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomText extends StatelessWidget {

  String text;
  Color? color;
  double size;
  FontWeight fontWeight;
  double? letterspacing;


  CustomText({required this.text, this.color, required this.size, required this.fontWeight,this.letterspacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //HERE ARE TWO TEXTSTYLE BECAUSE I ADDED GOOGLEFONTS TEXT SO IT REQUIRES TEXTSTYLE.
      style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: size,
        color: color,
        fontWeight: fontWeight,
        letterSpacing:letterspacing
      )),
      textAlign: TextAlign.start,
      softWrap: true,
    );
  }
}
