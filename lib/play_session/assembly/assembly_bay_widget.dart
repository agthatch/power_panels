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
    return Row(
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> widgets = widget.assemblyBay.getWidgets();
    return widgets;
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
