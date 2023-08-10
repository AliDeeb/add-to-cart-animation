import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddedTextAnimation extends StatefulWidget {
  const AddedTextAnimation({
    super.key,
    required this.addedTextFadeAnimation,
    required this.addedTextTranslateAnimation,
    required this.textColor,
  });

  final Animation<double> addedTextFadeAnimation;
  final Animation<Offset> addedTextTranslateAnimation;
  final Color textColor;

  @override
  State<AddedTextAnimation> createState() => _AddedTextAnimationState();
}

class _AddedTextAnimationState extends State<AddedTextAnimation> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.addedTextFadeAnimation,
      child: AnimatedBuilder(
        animation: widget.addedTextTranslateAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: widget.addedTextTranslateAnimation.value,
            child: child,
          );
        },
        child: Text(
          "Added",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
