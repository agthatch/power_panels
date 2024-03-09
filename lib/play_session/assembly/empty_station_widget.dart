import 'package:flutter/material.dart';

class EmptyStation extends StatelessWidget {
  final int bayNumber;

  const EmptyStation({super.key, required this.bayNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white60,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Icon(Icons.pending_outlined),
        ),
      ),
    );
  }
}
