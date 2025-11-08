import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Widget child;

  const ListItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
        child: child,
      ),
    );
  }
}
