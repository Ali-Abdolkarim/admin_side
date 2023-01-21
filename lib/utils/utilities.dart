import 'package:flutter/material.dart';

class TwoElementFirstExpanded extends StatelessWidget {
  final Widget first;
  final Widget second;
  final EdgeInsetsGeometry? padding;
  const TwoElementFirstExpanded(
    this.first,
    this.second, {
    this.padding,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [Expanded(child: first), second],
      ),
    );
  }
}
