import 'dart:async';

import 'package:async/async.dart';
import 'package:card/game_internals/panel/panel_node.dart';
import 'package:card/game_internals/playing_piece.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class Panel {
  final int dimX;
  final int dimY;

  late final List<List<PanelNode>> nodes;

  bool? canAcceptHoveringPiece;

  Panel({required this.dimX, required this.dimY}) {
    nodes = List.generate(dimX, (i) => List.generate(dimY, (j) => PanelNode()));
  }

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  handlePieceHovering(PlayingPiece piece, int x, int y) {
    print('handling piece hovering for node $x, $y');
    clearAllHighlights();

    List<XYCoordinate> offsetsToTest = _determineOffsetsToTest(piece);

    XYCoordinate focussedNode = XYCoordinate(x: x, y: y);
    List<PanelNode> targetNodes = [];
    bool obstructionFound = false;

    for (XYCoordinate offset in offsetsToTest) {
      XYCoordinate testCoordinate = focussedNode.offsetBy(offset);

      if (_coordinateIsOutOfRange(testCoordinate)) {
        obstructionFound = true;
      } else {
        PanelNode testNode = nodes[testCoordinate.x][testCoordinate.y];
        targetNodes.add(testNode);

        obstructionFound = obstructionFound || testNode.occupied;
      }
    }

    for (PanelNode node in targetNodes) {
      node.highlighted = true;
      node.obstructed = obstructionFound;
    }

    canAcceptHoveringPiece = !obstructionFound;
    _playerChanges.add(null);
  }

  void clearAllHighlights() {
    for (int i = 0; i < nodes.length; i++) {
      for (int j = 0; j < nodes[i].length; j++) {
        // print('clearing highlights for $i, $j');
        nodes[i][j].highlighted = false;
        nodes[i][j].obstructed = false;
      }
    }
    _playerChanges.add(null);
  }

  bool _coordinateIsOutOfRange(XYCoordinate testCoordinate) {
    return testCoordinate.x < 0 ||
        testCoordinate.y < 0 ||
        testCoordinate.x >= dimX ||
        testCoordinate.y >= dimY;
  }
}

List<XYCoordinate> _determineOffsetsToTest(PlayingPiece piece) {
  List<XYCoordinate> testOffsets = [];
  if (piece.handledNodeCoordinate != null) {
    for (XYCoordinate coordinate in piece.nodes) {
      testOffsets
          .add(coordinate.negativeOffsetBy(piece.handledNodeCoordinate!));
    }
  }

  for (XYCoordinate offset in testOffsets) {
    offset.rotate(piece.rotation);
    if (piece.mirrored) {
      offset.mirrorXDirection();
    }
  }

  return testOffsets;
}
