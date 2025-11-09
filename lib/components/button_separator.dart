import 'package:flutter/material.dart';

class ButtonSeparator extends StatelessWidget {
  const ButtonSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
