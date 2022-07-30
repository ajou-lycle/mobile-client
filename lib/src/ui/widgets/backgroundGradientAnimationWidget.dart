import 'package:flutter/material.dart';

class BackgroundGradientAnimationWidget extends StatefulWidget {
  final Widget child;
  final Color beginColor;
  final Color endColor;
  final Alignment beginAlignment;
  final Alignment endAlignment;
  final Duration duration;

  const BackgroundGradientAnimationWidget(
      {Key? key,
      required this.child,
      required this.beginColor,
      required this.endColor,
      required this.beginAlignment,
      required this.endAlignment,
      required this.duration})
      : super(key: key);

  @override
  State<BackgroundGradientAnimationWidget> createState() =>
      BackgroundGradientAnimationWidgetState();
}

class BackgroundGradientAnimationWidgetState
    extends State<BackgroundGradientAnimationWidget>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundGradientController;
  late final Animation _backgroundGradientAnimationForward;
  late final Animation _backgroundGradientAnimationReverse;

  @override
  initState() {
    _backgroundGradientController =
        AnimationController(vsync: this, duration: widget.duration);

    _backgroundGradientAnimationForward = ColorTween(
      begin: widget.beginColor,
      end: widget.endColor,
    ).animate(_backgroundGradientController)
      ..addListener(() {
        setState(() {});
      });

    _backgroundGradientAnimationReverse = ColorTween(
      begin: widget.endColor,
      end: widget.beginColor,
    ).animate(_backgroundGradientController);

    _backgroundGradientController.forward();

    _backgroundGradientController.addListener(() {
      if (_backgroundGradientController.status == AnimationStatus.completed) {
        _backgroundGradientController.reverse();
      } else if (_backgroundGradientController.status ==
          AnimationStatus.dismissed) {
        _backgroundGradientController.forward();
      }
    });

    super.initState();
  }

  @override
  dispose() {
    _backgroundGradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bound) {
          return LinearGradient(
              begin: widget.beginAlignment,
              end: widget.endAlignment,
              colors: [
                _backgroundGradientAnimationForward.value,
                _backgroundGradientAnimationReverse.value,
              ]).createShader(bound);
        },
        blendMode: BlendMode.srcATop,
        child: widget.child);
  }
}
