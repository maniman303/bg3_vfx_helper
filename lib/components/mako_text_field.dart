import 'package:flutter/material.dart';

class MakoTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? label;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const MakoTextField({
    super.key,
    this.controller,
    this.label,
    this.labelText,
    this.hintText,
    this.errorText,
  });

  @override
  State<MakoTextField> createState() => _MakoTextFieldState();
}

class _MakoTextFieldState extends State<MakoTextField> {
  Color _getContainerColor(ThemeData baseTheme, String? errorText) {
    return errorText == null ? baseTheme.colorScheme.primaryContainer : baseTheme.colorScheme.errorContainer;
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final errorText = widget.errorText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _getContainerColor(baseTheme, errorText),
          ),
          padding: const EdgeInsets.all(1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: errorText == null
                        ? baseTheme.colorScheme.onPrimaryContainer
                        : baseTheme.colorScheme.onErrorContainer,
                    fontWeight: errorText == null ? FontWeight.w400 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  child: widget.label ?? Text(widget.labelText ?? ""),
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.5),
                child: TextField(
                  controller: widget.controller,
                  style: TextStyle(fontSize: 15),
                  cursorHeight: 17,
                  cursorColor: errorText == null
                      ? baseTheme.colorScheme.secondary
                      : baseTheme.colorScheme.error,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    filled: true,
                    fillColor: baseTheme.colorScheme.surface,
                    hoverColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(6),
                    constraints: BoxConstraints(maxHeight: 36),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _getContainerColor(baseTheme, errorText), width: 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 5, 1),
            child: Text(
              errorText,
              style: TextStyle(color: baseTheme.colorScheme.error, fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
