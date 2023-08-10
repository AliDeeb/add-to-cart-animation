import 'package:flutter/material.dart';

class AddIconRotateAnimation extends StatelessWidget {
  const AddIconRotateAnimation({
    super.key,
    required this.rotate,
    required this.color,
  });

  final Animation<double> rotate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotate,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotate.value,
          child: child,
        );
      },
      child: Icon(Icons.add, size: 30, color: color),
    );
  }
}
