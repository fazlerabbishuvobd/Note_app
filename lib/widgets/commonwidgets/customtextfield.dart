import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
 const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.line
  });

  final TextEditingController controller;
  final String hint;
  final int line;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none, hintText: hint), maxLines: line,
    );
  }
}