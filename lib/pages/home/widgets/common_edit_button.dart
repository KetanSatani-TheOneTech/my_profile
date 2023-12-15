import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, required this.onClick});
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(minimumSize: const Size(50, 30)),
      onPressed: onClick,
      child: const Text('Edit'),
    );
  }
}
