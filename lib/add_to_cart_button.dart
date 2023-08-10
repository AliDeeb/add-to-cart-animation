import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animations/add_icon_rotate_animation.dart';
import 'animations/added_text_animation.dart';
import 'animations/cart_animation.dart';
import 'animations/dots_animation.dart';
import 'animations/text_scale_animation.dart';

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({
    super.key,
    this.activeColor = const Color.fromARGB(255, 110, 215, 115),
    this.inactiveColor = Colors.black,
    required this.width,
    required this.height,
    required this.duration,
    this.onEnd,
  });
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double height;
  final Duration duration;
  final VoidCallback? onEnd;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController rotateCartController;
  late AnimationController dotsController;
  late AnimationController shakeController;
  late AnimationController addedTextController;

  // Animations
  late Animation<double> addIconAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> cartRotateAnimation;
  late Animation<double> cartRunAnimation;
  late Animation<double> cartRun2Animation;
  late Animation<Offset> cartShakeAnimation;
  late Animation<double> addedTextFadeAnimation;
  late Animation<Offset> addedTextTranslateAnimation;

  // states
  final cartSize = const Size(25, 25);
  final startPadding = 25.0;
  bool _changeAddIconToCartIcon = false;
  set changeAddIconToCartIcon(bool v) {
    if (v == _changeAddIconToCartIcon) return;
    setState(() {
      _changeAddIconToCartIcon = v;
      if (_changeAddIconToCartIcon) {
        rotateCartController.forward();
      }
    });
  }

  bool _showDots = false;
  set showDots(bool v) {
    if (v == _showDots) return;
    setState(() {
      _showDots = v;
    });
  }

  bool _finishFirstTranslate = false;
  set finishFirstTranslate(bool v) {
    if (_finishFirstTranslate == v) return;

    setState(() {
      _finishFirstTranslate = v;
      if (_finishFirstTranslate) {
        Future.delayed(
            Duration(
              milliseconds:
                  ((.6 * widget.duration.inMilliseconds).toInt()) ~/ 2,
            ),
            () => rotateCartController.forward());
      }
    });
  }

  bool _finsihSecondTranslate = false;
  set finsihSecondTranslate(bool v) {
    if (_finsihSecondTranslate == v) return;
    setState(() {
      _finsihSecondTranslate = v;
      if (_finsihSecondTranslate) {
        addedTextController.forward();
      }
    });
  }

  late Color _textColor;
  set textColor(Color v) {
    if (v == _textColor) return;
    setState(() {
      _textColor = v;
    });
  }

  @override
  void initState() {
    super.initState();
    _textColor = widget.inactiveColor;

    // Controllers Durations
    final rDuration =
        Duration(milliseconds: (widget.duration.inMilliseconds * .2).toInt());
    final dotsDuration =
        Duration(milliseconds: (widget.duration.inMilliseconds * .5).toInt());
    final shakeDuration =
        Duration(milliseconds: (widget.duration.inMilliseconds * .125).toInt());
    final tDuration =
        Duration(milliseconds: (widget.duration.inMilliseconds * .5).toInt());

    // Controller (Intervals, Tweens)
    const rotateInterval = Interval(0, .2, curve: Curves.decelerate);
    const scaleInterval = Interval(0, .15, curve: Curves.ease);
    const cartRunInterval = Interval(.25, .4);
    const cartRun2Interval = Interval(.75, 1, curve: Curves.easeInCubic);
    final rotateTween = Tween<double>(begin: 0, end: -math.pi / 2);
    final scaleTween = Tween<double>(begin: 1.0, end: 0.7);
    final cartRunTween = Tween<double>(
      begin: 0,
      end: (widget.width / 2) - (cartSize.width / 2) - startPadding,
    );
    final cartRun2Tween = Tween<double>(
      begin: 0,
      end: widget.width / 2 + cartSize.width,
    );

    // Rotate Cart Controller (Tweens)
    final cartRotateTween = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(begin: 0, end: -math.pi / 6)
            ..chain(CurveTween(curve: Curves.ease)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -math.pi / 6, end: 0)
            ..chain(CurveTween(curve: Curves.easeInOutExpo)),
          weight: 50,
        ),
      ],
    );

    // Shake Controller (Tweens)
    final shakeTween = TweenSequence<Offset>(
      [
        TweenSequenceItem(
          tween: Tween(begin: Offset.zero, end: const Offset(0, 1)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 1), end: Offset.zero),
          weight: 1,
        ),
        // TweenSequenceItem(
        //   tween: Tween(begin: Offset.zero, end: const Offset(0, 3)),
        //   weight: 1,
        // ),
        // TweenSequenceItem(
        //   tween: Tween(begin: const Offset(0, 3), end: const Offset(0, -2)),
        //   weight: 1,
        // ),
        // TweenSequenceItem(
        //   tween: Tween(begin: const Offset(0, -2), end: const Offset(0, 1)),
        //   weight: 1,
        // ),
        // TweenSequenceItem(
        //   tween: Tween(begin: const Offset(0, 1), end: const Offset(0, -1)),
        //   weight: 1,
        // ),
        // TweenSequenceItem(
        //   tween: Tween(begin: const Offset(0, -1), end: const Offset(0, 1)),
        //   weight: 1,
        // ),
        // TweenSequenceItem(
        //   tween: Tween(begin: const Offset(0, 1), end: Offset.zero),
        //   weight: 1,
        // ),
      ],
    );

    // Added Text Controller (Tweens)
    final addedTextFadeTween = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 50),
    ]);
    final addedTextTranslateTween = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 15), end: Offset.zero),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -15)),
        weight: 50,
      ),
    ]);

    // Setup Controllers
    controller = AnimationController(vsync: this, duration: widget.duration);
    rotateCartController = AnimationController(vsync: this, duration: rDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotateCartController.reset();
        }
      });
    dotsController = AnimationController(vsync: this, duration: dotsDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          textColor = widget.activeColor;
        }
      });
    shakeController = AnimationController(vsync: this, duration: shakeDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) shakeController.reset();
      });
    addedTextController = AnimationController(vsync: this, duration: tDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          resetStates();
          widget.onEnd?.call();
        }
      });

    // Controller (Animations)
    // Change add icon to cart icon animation.
    addIconAnimation = rotateTween.animate(
      CurvedAnimation(parent: controller, curve: rotateInterval)
        ..addListener(() {
          if (addIconAnimation.value == rotateTween.end) {
            changeAddIconToCartIcon = true;
          }
        }),
    );
    // Text scale animation.
    scaleAnimation = scaleTween.animate(
      CurvedAnimation(parent: controller, curve: scaleInterval)
        ..addListener(() {
          if (scaleAnimation.value == scaleTween.end) {
            showDots = true;
          }
        }),
    );
    // Cart running animation.
    cartRunAnimation = cartRunTween.animate(
      CurvedAnimation(parent: controller, curve: cartRunInterval),
    )..addListener(() {
        if (cartRunTween.end == cartRunAnimation.value) {
          finishFirstTranslate = true;
        }
      });
    cartRun2Animation = cartRun2Tween.animate(
      CurvedAnimation(parent: controller, curve: cartRun2Interval),
    )..addListener(() {
        if (cartRun2Tween.end == cartRun2Animation.value) {
          finsihSecondTranslate = true;
        }
      });

    // Rotate cart controller (Animations)
    // Cart rotate animation.
    cartRotateAnimation = cartRotateTween.animate(rotateCartController);

    // Shake controller (Animations)
    // Cart shake animation.
    cartShakeAnimation = shakeTween.animate(shakeController);

    // Added text controller (Animations)
    // Added text fade animation.
    addedTextFadeAnimation = addedTextFadeTween.animate(addedTextController);
    // Added text translate animation.
    addedTextTranslateAnimation =
        addedTextTranslateTween.animate(addedTextController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      clipBehavior: Clip.hardEdge,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(0, 20),
            blurRadius: 15,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              // (Add to cart text, Dots)
              Center(
                child: _showDots
                    ? DotsAnimation(
                        dotsController: dotsController,
                        shakeController: shakeController,
                        containerSize: Size(widget.width, widget.height),
                      )
                    : TextScaleAnimation(
                        scaleAnimation: scaleAnimation,
                        color: _textColor,
                      ),
              ),

              // Added text
              Center(
                child: AddedTextAnimation(
                  addedTextFadeAnimation: addedTextFadeAnimation,
                  addedTextTranslateAnimation: addedTextTranslateAnimation,
                  textColor: _textColor,
                ),
              ),

              // icons (add, Cart)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: startPadding),
                  child: _changeAddIconToCartIcon
                      ? CartAnimation(
                          cartSize: cartSize,
                          cartIconColor: _textColor,
                          cartRotateAnimation: cartRotateAnimation,
                          cartTranslateAnimation: cartRunAnimation,
                          cartTranslate2Animation: cartRun2Animation,
                          cartChakeAnimation: cartShakeAnimation,
                        )
                      : AddIconRotateAnimation(
                          rotate: addIconAnimation,
                          color: _textColor,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (controller.isDismissed) {
      controller.forward();
    }
  }

  void resetStates() {
    controller.reset();

    // reset states
    changeAddIconToCartIcon = false;
    showDots = false;
    finishFirstTranslate = false;
    finsihSecondTranslate = false;
    textColor = widget.inactiveColor;
    dotsController.reset();
    addedTextController.reset();
  }

  @override
  void dispose() {
    controller.dispose();
    rotateCartController.dispose();
    dotsController.dispose();
    shakeController.dispose();
    addedTextController.dispose();
    super.dispose();
  }
}
