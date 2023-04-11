import 'package:flutter/material.dart';

/// For Debugging Purposes Only
class DevBorderedBox extends StatelessWidget {
  const DevBorderedBox({
    this.child,
    this.color = Colors.red,
    super.key,
  });

  final Widget? child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color),
      ),
      child: child,
    );
  }
}
