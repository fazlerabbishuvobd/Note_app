import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  const CustomIconButton({super.key, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon,size: 30,));
  }
}
