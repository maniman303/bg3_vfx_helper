import 'package:bg3_vfx_helper/helpers/list_extensions.dart';
import 'package:flutter/material.dart';

class LastWrap extends StatelessWidget {
  const LastWrap({
    super.key,
    this.spacing = 20,
    this.runSpacing = 7,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    required this.children,
  });

  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            crossAxisAlignment: crossAxisAlignment,
            alignment: WrapAlignment.end,
            children: [
              ...children
                  .sublistLength(children.length - 1)
                  .map(
                    (w) => ExcludeFocus(
                      child: IgnorePointer(child: Opacity(opacity: 0.0, child: w)),
                    ),
                  ),
              if (children.lastOrNull != null) children.last,
            ],
          ),
        ),
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...children.sublistLength(children.length - 1),
            if (children.lastOrNull != null)
              ExcludeFocus(
                child: IgnorePointer(child: Opacity(opacity: 0.0, child: children.last)),
              ),
          ],
        ),
      ],
    );
  }
}
