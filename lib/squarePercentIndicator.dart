library square_percent_indicater;

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:square_percent_indicater/Matrix4.dart';

class MySquarePercentIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double progress;

  ///animation
  final bool animation;
  final int animationDuration;
  final bool restartAnimation;
  final bool animateFromLastPercent;
  final bool addAutomaticKeepAlive;

  /// Callback called when the animation ends (only if `animation` is true)
  final VoidCallback onAnimationEnd;

  ///square border radius
  final double borderRadius;
  final Color progressColor;
  final Color shadowColor;

  ///thickness of the progress
  final double progressWidth;
  final double shadowWidth;
  final Widget child;

  ///if true the progress is moving clockwise
  final bool reverse;

  final StartAngle startAngle;

  const MySquarePercentIndicator(
      {Key key,
      this.progress = 0.0,
      this.animation = false,
      this.animationDuration = 500,
      this.restartAnimation = false,
      this.onAnimationEnd,
      this.animateFromLastPercent = false,
      this.addAutomaticKeepAlive = true,
      this.reverse = false,
      this.borderRadius = 5,
      this.progressColor = Colors.blue,
      this.shadowColor = Colors.grey,
      this.progressWidth = 5,
      this.shadowWidth = 5,
      this.child,
      this.startAngle,
      this.width = 150,
      this.height = 150})
      : super(key: key);
  @override
  _MySquarePercentIndicatorState createState() =>
      _MySquarePercentIndicatorState();
}

class _MySquarePercentIndicatorState extends State<MySquarePercentIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _animationController;
  Animation _animation;
  double _percent = 0.0;
  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.animation) {
      _animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.animationDuration));
      _animation = Tween(begin: 0.0, end: widget.progress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear),
      )..addListener(() {
          setState(() {
            _percent = _animation.value;
          });
          if (widget.restartAnimation && _percent == 1.0) {
            _animationController.repeat(min: 0, max: 1.0);
          }
        });
      _animationController.addStatusListener((status) {
        if (widget.onAnimationEnd != null &&
            status == AnimationStatus.completed) {
          widget.onAnimationEnd();
        }
      });
      _animationController.forward();
    } else {
      _updateProgress();
    }
    super.initState();
  }

  void _checkIfNeedCancelAnimation(MySquarePercentIndicator oldWidget) {
    if (oldWidget.animation &&
        !widget.animation &&
        _animationController != null) {
      _animationController.stop();
    }
  }

  @override
  void didUpdateWidget(MySquarePercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.startAngle != widget.startAngle) {
      if (_animationController != null) {
        _animationController.duration =
            Duration(milliseconds: widget.animationDuration);
        _animation = Tween(
                begin: widget.animateFromLastPercent ? oldWidget.progress : 0.0,
                end: widget.progress)
            .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear),
        );
        _animationController.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
    _checkIfNeedCancelAnimation(oldWidget);
  }

  _updateProgress() {
    setState(() {
      _percent = widget.progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        child: widget.child ?? Container(),
        painter: RadialPainter(
            startAngle: widget.startAngle,
            progress: _percent,
            color: widget.progressColor,
            shadowColor: widget.shadowColor,
            reverse: widget.reverse,
            strokeCap: StrokeCap.round,
            paintingStyle: PaintingStyle.stroke,
            strokeWidth: widget.progressWidth,
            shadowWidth: widget.shadowWidth,
            borderRadius: widget.borderRadius),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}

class RadialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color shadowColor;
  final StrokeCap strokeCap;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final double shadowWidth;
  final double borderRadius;
  final bool reverse;
  final StartAngle startAngle;

  RadialPainter({
    this.progress,
    this.color,
    this.shadowColor,
    this.strokeWidth,
    this.shadowWidth,
    this.reverse,
    this.strokeCap,
    this.paintingStyle,
    this.startAngle = StartAngle.topLeft,
    this.borderRadius = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    Paint shadowPaint = Paint()
      ..strokeWidth = shadowWidth
      ..color = shadowColor
      ..style = paintingStyle
      ..strokeCap = strokeCap;

    var path = Path();
    Path dashPath = Path();

    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(size.width - borderRadius, borderRadius),
            radius: borderRadius),
        -pi / 2,
        pi / 2,
        false);
    path.lineTo(size.width, size.height - borderRadius);
    path.arcTo(
        Rect.fromCircle(
            center:
                Offset(size.width - borderRadius, size.height - borderRadius),
            radius: borderRadius),
        0,
        pi / 2,
        false);
    path.lineTo(0 + borderRadius, size.height);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(borderRadius, size.height - borderRadius),
            radius: borderRadius),
        pi / 2,
        pi / 2,
        false);
    path.lineTo(0, borderRadius);
    path.arcTo(
        Rect.fromCircle(
            center: Offset(borderRadius, borderRadius), radius: borderRadius),
        pi,
        pi / 2,
        false);

    for (PathMetric pathMetric in path.computeMetrics()) {
      dashPath.addPath(
        pathMetric.extractPath(0, pathMetric.length * progress),
        Offset.zero,
      );
    }

    if (reverse) {
      dashPath = dashPath
          .transform(Matrix4Transform().rotate(pi / 2).m.storage)
          .transform(Matrix4Transform().flipHorizontally().m.storage);
    }

    dashPath = dashPath.transform(
        Matrix4Transform().rotateByCenter(startAngle.value, size).m.storage);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum StartAngle { topRight, topLeft, bottomRight, bottomLeft }

extension GetValue on StartAngle {
  double get value => getRotationAngle;

  double get getRotationAngle {
    switch (this) {
      case StartAngle.topLeft:
        return 0;
      case StartAngle.topRight:
        return pi * 0.5;
      case StartAngle.bottomRight:
        return pi * 1.0;
      case StartAngle.bottomLeft:
        return pi * 1.5;
      default:
        return 0;
    }
  }
}
