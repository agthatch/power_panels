import 'package:card/game_internals/assembly/assembly_bay.dart';
import 'package:flutter/material.dart';

class AssemblyBayWidget extends StatefulWidget {
  final AssemblyBay assemblyBay;

  const AssemblyBayWidget({super.key, required this.assemblyBay});

  @override
  State<AssemblyBayWidget> createState() => _AssemblyBayWidgetState();
}

class _AssemblyBayWidgetState extends State<AssemblyBayWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: widget.assemblyBay.playerChanges,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [...widget.assemblyBay.getWidgets()],
              ),
            );
          }),
    );
  }

  @override
  void didUpdateWidget(covariant AssemblyBayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the AssemblyBay object has changed
    if (oldWidget.assemblyBay != widget.assemblyBay) {
      setState(() {
        // Update the UI with the new AssemblyBay object
      });
    }
  }
}
