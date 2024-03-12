// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/play_session/blueprint/blueprint_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../game_internals/card/score.dart';
import '../style/wiggle_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            Center(
              child: Text(
                score.win ? 'You won!' : 'You lost.',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Total Capacity: ${score.score}\n'
                'Day: ${score.day}',
                style: const TextStyle(
                    fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
            _showBlueprints(score.blueprints),
          ],
        ),
        rectangularMenuArea: WiggleButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }

  Widget _showBlueprints(List<Blueprint> blueprints) {
    return Expanded(
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 0,
          runSpacing: 0,
          children: [
            ...blueprints.map((blueprint) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [BlueprintWidget(blueprint: blueprint)],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
