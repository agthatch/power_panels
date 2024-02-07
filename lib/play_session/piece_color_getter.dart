import 'package:card/game_internals/piece/piece_data.dart';
import 'package:card/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PieceColorGetter {
  static Color get(Shape shape, BuildContext context) {
    Palette palette = context.watch<Palette>();
    switch (shape) {
      case Shape.single:
        return palette.pieceSingle;
      case Shape.lineTwo:
        return palette.pieceLine2;
      case Shape.lineThree:
        return palette.pieceLine3;
      case Shape.corner:
        return palette.pieceCorner;
      case Shape.square:
        return palette.pieceSquare;
      case Shape.T:
        return palette.pieceT;
      case Shape.Z:
        return palette.pieceZ;
      case Shape.L:
        return palette.pieceL;
      case Shape.lineFour:
        return palette.pieceLine4;
    }
  }
}
