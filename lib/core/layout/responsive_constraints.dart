import 'package:flutter/material.dart';

class ResponsiveConstraints extends StatelessWidget {
  const ResponsiveConstraints({
    required this.child,
    this.maxWidth = 720,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
