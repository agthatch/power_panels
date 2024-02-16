import 'package:flutter/material.dart';

class EmptyStation extends StatelessWidget {
  final int bayNumber;

  const EmptyStation({super.key, required this.bayNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            // Text in upper-left corner
            Positioned(
              top: 8,
              left: 8,
              child: Text(
                'Empty Bay #$bayNumber',
                style: TextStyle(fontSize: 12),
              ),
            ),
            // Other content of the card can be added here
          ],
        ),
      ),
    );
  }
}
