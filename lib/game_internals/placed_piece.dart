import 'package:card/game_internals/playing_piece.dart';
import 'package:card/game_internals/xy_coordinate.dart';

class PlacedPiece {
  final PlayingPiece piece;
  final XYCoordinate location;
  bool accepted;

  PlacedPiece(
      {required this.piece, required this.location, this.accepted = false}) {
    //we need to determine the upper left corner node, and translate the coordinate
    //to coorespond with that node
  }

  static PlacedPiece create(
      {required PlayingPiece piece,
      required int x,
      required int y,
      bool accepted = false}) {
    XYCoordinate offsetFromClickedNodeToTopLeftCorner =
        piece.getOffsetFromClickedNodeToTopLeftCorner();

    piece.isPlaced = accepted;

    XYCoordinate pieceLocation = XYCoordinate(x: x, y: y);
    pieceLocation =
        pieceLocation.offsetBy(offsetFromClickedNodeToTopLeftCorner);

    return PlacedPiece(
        piece: piece, location: pieceLocation, accepted: accepted);
  }
}
