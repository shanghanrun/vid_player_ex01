import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const CustomIconButton(
      {required this.onPressed, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 30,
      color: Colors.white,
    );
  }
}
