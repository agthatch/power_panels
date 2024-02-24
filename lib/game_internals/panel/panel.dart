import 'dart:async';

import 'package:async/async.dart';
import 'package:card/game_internals/blueprint/blueprint.dart';
import 'package:card/game_internals/card/board_state.dart';
import 'package:card/game_internals/card/player.dart';
import 'package:card/game_internals/panel/panel_node.dart';
import 'package:card/game_internals/piece/placed_piece.dart';
import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/rounds/actions/staged_piece.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class Panel {
  final int dimX;
  final int dimY;
  final int generationValue;
  late int nodeCount;

  bool puzzleComplete = false;

  late final List<List<PanelNode>> nodes;
  List<PlacedPiece> placedPieces = [];
  List<PlacedPiece> stagedPieces = [];

  bool? canAcceptHoveringPiece;

  Panel(
      {required this.generationValue, required this.dimX, required this.dimY}) {
    nodes = List.generate(dimX, (i) => List.generate(dimY, (j) => PanelNode()));
    nodeCount = dimX * dimY;
  }

  static Panel fromBlueprint(Blueprint blueprint) {
    Panel res = Panel(
        generationValue: blueprint.generationValue,
        dimX: blueprint.xDim,
        dimY: blueprint.yDim);
    for (PlacedPiece piece in blueprint.preFitPieces) {
      res._placePiece(piece);
    }

    return res;
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
    clearAllHighlights();

    if (stagedPieces.isNotEmpty) {
      _playerChanges.add(null);
      canAcceptHoveringPiece = false;
      return;
    }

    List<PanelNode> targetNodes = extractValidTargetNodes(piece, x, y);
    bool obstructionFound = piece.size > targetNodes.length;

    for (PanelNode node in targetNodes) {
      node.highlighted = true;
      node.obstructed = obstructionFound;
    }

    canAcceptHoveringPiece = !obstructionFound;
    _playerChanges.add(null);
  }

  unstagePieces() {
    stagedPieces.clear();
    _playerChanges.add(null);
  }

  handlePiecePlacement(PlacedPiece piece) {
    _placePiece(piece);
  }

  _placePiece(PlacedPiece piece) {
    placedPieces.add(piece);
    clearAllHighlights();

    List<PanelNode> targetNodes = extractValidTargetNodes(
        piece.piece, piece.location.x, piece.location.y);

    for (PanelNode node in targetNodes) {
      node.occupied = true;
    }

    _updateOccupiedCount();
    _playerChanges.add(null);
  }

  _updateOccupiedCount() {
    int occupiedCount = 0;
    for (List<PanelNode> row in nodes) {
      for (PanelNode node in row) {
        if (node.occupied) {
          occupiedCount++;
        }
      }
    }

    puzzleComplete = occupiedCount >= nodeCount;
  }

  handlePieceStagingAndNotifyBoard(
      PlayingPiece piece, Player player, int x, int y, BoardState boardState) {
    PlacedPiece placedPiece =
        PlacedPiece.create(piece: piece, x: x, y: y, isStaged: piece.isStaged);
    stagedPieces.add(placedPiece);
    clearAllHighlights();
    _playerChanges.add(null);
    boardState.handleStagedPiece(
        StagedPiece(piece: placedPiece, panel: this, player: player));
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

  List<PlacedPiece> placedAndStagedPieces() {
    return [...placedPieces, ...stagedPieces];
  }
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
