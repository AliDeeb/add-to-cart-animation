import 'package:flutter/material.dart';

class DotsAnimation extends StatefulWidget {
  const DotsAnimation({
    super.key,
    required this.dotsController,
    required this.shakeController,
    required this.containerSize,
  });

  final AnimationController dotsController;
  final AnimationController shakeController;
  final Size containerSize;

  @override
  State<DotsAnimation> createState() => _DotsAnimationState();
}

class _DotsAnimationState extends State<DotsAnimation> {
  final dotsColors = [
    Colors.deepPurpleAccent.shade700,
    Colors.green,
    Colors.amber,
    Colors.red
  ];

  late Animation<double> distanceAnimation;
  late Animation<double> scaleAnimation;
  late List<Animation<Offset>> translateAnimation;
  late Animation<double> hideAnimation;
  late List<GlobalKey> keys;
  final rowKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    keys = List.generate(4, (index) => GlobalKey());

    distanceAnimation = Tween<double>(begin: 7, end: 0).animate(
      CurvedAnimation(
        parent: widget.dotsController,
        curve: const Interval(0, 0.2, curve: Curves.decelerate),
      ),
    );

    scaleAnimation = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: widget.dotsController,
        curve: const Interval(0.15, 0.2),
      ),
    );

    hideAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: widget.dotsController,
        curve: const Interval(0.99, 1.0),
      ),
    );

    translateAnimation = List.generate(4, (index) {
      return Tween<Offset>(begin: Offset.zero, end: Offset.zero)
          .animate(widget.dotsController);
    });

    // After call build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Offset> centers = List.generate(4, (index) => Offset.zero);

      for (int i = 0; i < keys.length; i++) {
        final position = (keys[i].currentContext!.findRenderObject()
                as RenderBox)
            .localToGlobal(Offset.zero,
                ancestor:
                    (rowKey.currentContext!.findRenderObject() as RenderBox));
        centers[i] = Offset((widget.containerSize.width / 2) - position.dx, 0);
      }

      const translateAnimationInterval = [
        Interval(0.2, 0.75),
        Interval(0.2, 0.9),
        Interval(0.2, 0.95),
        Interval(0.2, 1.0),
      ];
      translateAnimation = List.generate(
        4,
        (index) {
          return TweenSequence<Offset>(
            [
              TweenSequenceItem(
                tween: Tween(
                  begin: Offset.zero,
                  end: Offset(centers[index].dx + 5, -50),
                ).chain(CurveTween(curve: Curves.ease)),
                weight: 50 + (index * 10),
              ),
              TweenSequenceItem(
                tween: Tween(
                  begin: Offset(centers[index].dx + 5, -50),
                  end: centers[index],
                ).chain(
                  CurveTween(curve: Curves.easeInExpo),
                ),
                weight: 50 - (index * 10),
              ),
            ],
          ).animate(
            CurvedAnimation(
              parent: widget.dotsController,
              curve: translateAnimationInterval[index],
            ),
          );
        },
      );

      widget.dotsController.forward();

      for (var i in translateAnimationInterval) {
        Future.delayed(
          Duration(
            milliseconds:
                (widget.dotsController.duration!.inMilliseconds * i.end)
                    .toInt(),
          ),
          () {
            if (widget.shakeController.isAnimating) {
              widget.shakeController.reset();
            }
            widget.shakeController.forward();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: rowKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < translateAnimation.length; i++) ...[
          ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: hideAnimation,
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([translateAnimation[i], hideAnimation]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: translateAnimation[i].value,
                    child: child,
                  );
                },
                child: DotWidget(key: keys[i], color: dotsColors[i]),
              ),
            ),
          ),

          // distance
          AnimatedBuilder(
            animation: distanceAnimation,
            builder: (context, _) {
              return SizedBox(width: distanceAnimation.value);
            },
          ),
        ]
      ],
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
