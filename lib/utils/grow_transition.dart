import 'package:flutter/material.dart';

class GrowTransition extends StatelessWidget {
  final Widget? child;
  final Animation<double>? animation;
  final sizeTween = Tween<double>(begin: 150, end: 170);
  // final opacityTween = Tween<double>(begin: 0.1, end: 1);
  GrowTransition({Key? key, this.child, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return SizedBox(
            height: sizeTween.evaluate(animation!),
            width: sizeTween.evaluate(animation!),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
