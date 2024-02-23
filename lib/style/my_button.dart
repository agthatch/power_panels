// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

class WiggleButton extends StatefulWidget {
  final Widget child;

  final VoidCallback? onPressed;

  const WiggleButton({super.key, required this.child, this.onPressed});

  @override
  State<WiggleButton> createState() => _WiggleButtonState();
}

class _WiggleButtonState extends State<WiggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.repeat();
      },
      onExit: (event) {
        _controller.reset();
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: FilledButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
