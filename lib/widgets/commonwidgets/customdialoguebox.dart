import 'package:flutter/material.dart';

class CustomDialogueBox extends StatelessWidget {
  const CustomDialogueBox({
    super.key,
    this.controller,
    this.title,
    this.onPressedSave,
    this.controllerData
  });

  final TextEditingController? controller;
  final String? title;
  final VoidCallback? onPressedSave;
  final String? controllerData;

  @override
  Widget build(BuildContext context) {
    controller!.text = '$controllerData';
    return AlertDialog(
      title: Text('$title'),
      content: TextField(
        controller: controller,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMaterialButtonCancel(context),
            _buildMaterialButtonSave(),
          ],
        ),
      ],
    );
  }

  MaterialButton _buildMaterialButtonSave() {
    return MaterialButton(
            onPressed:onPressedSave,
            height: 50,
            color: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text('Save'), Icon(Icons.save)],
            ),
          );
  }

  MaterialButton _buildMaterialButtonCancel(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      height: 50,
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text('Cancel'), Icon(Icons.cancel)],
      ),
    );
  }
}
