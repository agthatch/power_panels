import 'package:card/game_internals/piece/playing_piece.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlacedPiece {
  final PlayingPiece piece;
  final XYCoordinate location;
  bool isStaged;

  PlacedPiece(
      {required this.piece, required this.location, this.isStaged = false}) {
    //we need to determine the upper left corner node, and translate the coordinate
    //to coorespond with that node
  }

  static PlacedPiece create(
      {required PlayingPiece piece,
      required int x,
      required int y,
      bool isStaged = false}) {
    XYCoordinate offsetFromClickedNodeToTopLeftCorner =
        piece.getOffsetFromClickedNodeToTopLeftCorner();

    piece.isStaged = isStaged;

    XYCoordinate pieceLocation = XYCoordinate(x: x, y: y);
    pieceLocation =
        pieceLocation.offsetBy(offsetFromClickedNodeToTopLeftCorner);

    piece.handledNodeCoordinate = XYCoordinate(x: 0, y: 0);

    return PlacedPiece(
        piece: piece, location: pieceLocation, isStaged: isStaged);
  }
}
