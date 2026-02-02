import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// A widget that centers its child and constrains its width on larger screens.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxContentWidth = Breakpoints.tablet,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxContentWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxContentWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
