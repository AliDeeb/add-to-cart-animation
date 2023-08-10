import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartAnimation extends StatelessWidget {
  const CartAnimation({
    super.key,
    required this.cartIconColor,
    required this.cartRotateAnimation,
    required this.cartTranslateAnimation,
    required this.cartTranslate2Animation,
    required this.cartChakeAnimation,
    required this.cartSize,
  });

  final Color cartIconColor;
  final Animation<double> cartRotateAnimation;
  final Animation<double> cartTranslateAnimation;
  final Animation<double> cartTranslate2Animation;
  final Animation<Offset> cartChakeAnimation;
  final Size cartSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        cartRotateAnimation,
        cartTranslateAnimation,
        cartTranslate2Animation,
        cartChakeAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(cartTranslateAnimation.value, 0),
          child: Transform.translate(
            offset: Offset(cartTranslate2Animation.value, 0),
            child: Transform.translate(
              offset: cartChakeAnimation.value,
              child: Transform.rotate(
                angle: cartRotateAnimation.value,
                child: child,
              ),
            ),
          ),
        );
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 100),
        tween: Tween(begin: 0.5, end: 1.0),
        curve: Curves.decelerate,
        builder: (_, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: SvgPicture.asset(
          "assets/cart_icon.svg",
          width: cartSize.width,
          height: cartSize.height,
          color: cartIconColor,
        ),
      ),
    );
  }
}
