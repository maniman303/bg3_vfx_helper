import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String text;

  const ListHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 6, horizontal: 3),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20),
        ),
      ),
    );
  }
}
