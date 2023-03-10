import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CText extends StatelessWidget {
  final String text;
  final double? sizee;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;
  final bool? underLine;
  final EdgeInsetsGeometry? padding;
  const CText(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.sizee,
    this.align,
    this.underLine,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        style: GoogleFonts.ubuntu(
            fontSize: sizee ?? 16,
            fontWeight: weight ?? FontWeight.normal,
            color: color ?? Colors.black,
            decoration: (underLine ?? false)
                ? TextDecoration.underline
                : TextDecoration.none),
        textAlign: align ?? TextAlign.center,
      ),
    );
  }
}
