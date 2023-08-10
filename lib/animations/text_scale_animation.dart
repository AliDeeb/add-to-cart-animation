import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextScaleAnimation extends StatelessWidget {
  const TextScaleAnimation({
    super.key,
    required this.scaleAnimation,
    required this.color,
  });

  final Animation<double> scaleAnimation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Text(
        "Add to cart",
        style: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 17,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
