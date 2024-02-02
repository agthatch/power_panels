import 'dart:async';

import 'package:async/async.dart';
import 'package:card/game_internals/panel/panel_node.dart';
import 'package:card/game_internals/placed_piece.dart';
import 'package:card/game_internals/playing_piece.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class Panel {
  final int dimX;
  final int dimY;

  late final List<List<PanelNode>> nodes;
  List<PlacedPiece> placedPieces = [];

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

    List<PanelNode> targetNodes = extractValidTargetNodes(piece, x, y);
    bool obstructionFound = piece.size > targetNodes.length;

    for (PanelNode node in targetNodes) {
      node.highlighted = true;
      node.obstructed = obstructionFound;
    }

    canAcceptHoveringPiece = !obstructionFound;
    _playerChanges.add(null);
  }

  handlePiecePlacement(PlayingPiece piece, int x, int y) {
    print("handling PiecePlacement $x, $y");
    placedPieces
        .add(PlacedPiece.create(piece: piece, x: x, y: y, accepted: true));
    clearAllHighlights();

    List<PanelNode> targetNodes = extractValidTargetNodes(piece, x, y);

    for (PanelNode node in targetNodes) {
      node.occupied = true;
    }

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

  List<PanelNode> extractValidTargetNodes(PlayingPiece piece, int x, int y) {
    List<XYCoordinate> offsetsToTest = _determineOffsetsToTestFromShape(piece);

    XYCoordinate focussedNode = XYCoordinate(x: x, y: y);
    List<PanelNode> targetNodes = [];

    List<XYCoordinate> activeNodesCoordinates = [];
    for (XYCoordinate offset in offsetsToTest) {
      XYCoordinate testCoordinate = focussedNode.offsetBy(offset);
      activeNodesCoordinates.add(testCoordinate);

      if (!_coordinateIsOutOfRange(testCoordinate)) {
        PanelNode testNode = nodes[testCoordinate.x][testCoordinate.y];
        if (!testNode.occupied) {
          targetNodes.add(testNode);
        }
      }
    }
    return targetNodes;
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

List<XYCoordinate> _determineOffsetsToTestFromShape(PlayingPiece piece) {
  List<XYCoordinate> testOffsets = [];
  if (piece.handledNodeCoordinate != null) {
    for (XYCoordinate coordinate in piece.nodes) {
      testOffsets
          .add(coordinate.negativeOffsetBy(piece.handledNodeCoordinate!));
    }
  }

  return testOffsets;
}
