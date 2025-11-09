import 'package:async_locks/async_locks.dart';
import 'package:flutter/material.dart';

class LockableFilledIconButton extends StatefulWidget {
  const LockableFilledIconButton({
    super.key,
    this.lock,
    required this.onPressed,
    required this.icon,
    this.height,
  });

  final Lock? lock;
  final Future<void> Function()? onPressed;
  final Widget icon;
  final double? height;

  @override
  State<LockableFilledIconButton> createState() => _LockableFilledIconButtonState();
}

class _LockableFilledIconButtonState extends State<LockableFilledIconButton> {
  late Lock _lock;

  void _onPressed() async {
    if (_lock.locked || !mounted) {
      return;
    }

    await _lock.acquire();

    final fun = widget.onPressed;
    if (fun != null) {
      await fun();
    }

    if (!mounted) {
      return;
    }

    _lock.release();
  }

  @override
  void didChangeDependencies() {
    _lock = widget.lock ?? Lock();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height;

    return IconButton.filledTonal(
      onPressed: widget.onPressed != null ? _onPressed : null,
      icon: widget.icon,
      padding: EdgeInsets.all(0),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryContainer),
        fixedSize: WidgetStatePropertyAll(Size(42, height ?? 42)),
      ),
    );
  }
}

class LockableFilledButton extends StatefulWidget {
  const LockableFilledButton({super.key, this.lock, required this.onPressed, required this.label, this.icon});

  final Lock? lock;
  final Future<void> Function()? onPressed;
  final Widget label;
  final Widget? icon;

  @override
  State<LockableFilledButton> createState() => _LockableFilledButtonState();
}

class _LockableFilledButtonState extends State<LockableFilledButton> {
  late Lock _lock;

  void _onPressed() async {
    if (_lock.locked || !mounted) {
      return;
    }

    await _lock.acquire();

    final fun = widget.onPressed;
    if (fun != null) {
      await fun();
    }

    if (!mounted) {
      return;
    }

    _lock.release();
  }

  @override
  void didChangeDependencies() {
    _lock = widget.lock ?? Lock();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: widget.onPressed != null ? _onPressed : null,
      label: widget.label,
      icon: widget.icon,
    );
  }
}

class LockableOutlinedButton extends StatefulWidget {
  const LockableOutlinedButton({
    super.key,
    this.lock,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final Lock? lock;
  final Future<void> Function()? onPressed;
  final Widget label;
  final Widget? icon;

  @override
  State<LockableOutlinedButton> createState() => _LockableOutlinedButtonState();
}

class _LockableOutlinedButtonState extends State<LockableOutlinedButton> {
  late Lock _lock;

  void _onPressed() async {
    if (_lock.locked || !mounted) {
      return;
    }

    await _lock.acquire();

    final fun = widget.onPressed;
    if (fun != null) {
      await fun();
    }

    if (!mounted) {
      return;
    }

    _lock.release();
  }

  @override
  void didChangeDependencies() {
    _lock = widget.lock ?? Lock();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: widget.onPressed != null ? _onPressed : null,
      label: widget.label,
      icon: widget.icon,
    );
  }
}

class LockableTextButton extends StatefulWidget {
  const LockableTextButton({super.key, this.lock, required this.onPressed, required this.label, this.icon});

  final Lock? lock;
  final Future<void> Function()? onPressed;
  final Widget label;
  final Widget? icon;

  @override
  State<LockableTextButton> createState() => _LockableTextButtonState();
}

class _LockableTextButtonState extends State<LockableTextButton> {
  late Lock _lock;

  void _onPressed() async {
    if (_lock.locked || !mounted) {
      return;
    }

    await _lock.acquire();

    final fun = widget.onPressed;
    if (fun != null) {
      await fun();
    }

    if (!mounted) {
      return;
    }

    _lock.release();
  }

  @override
  void didChangeDependencies() {
    _lock = widget.lock ?? Lock();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: widget.onPressed != null ? _onPressed : null,
      label: widget.label,
      icon: widget.icon,
    );
  }
}
