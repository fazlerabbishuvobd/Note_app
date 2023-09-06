import 'package:flutter/material.dart';

class NoNotesFound extends StatelessWidget {
  const NoNotesFound({
    super.key,
    required this.height,
    required this.width,
    required this.message,
  });

  final double height;
  final double width;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height*0.4,
      width: width,
      child: Text(message),
    );
  }
}

class AddFolderIcon extends StatelessWidget {
  const AddFolderIcon({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Container(
          width: width*0.2,
          height: height*0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black,width: 1)
          ),
          child: const Icon(Icons.add)),
    );
  }
}
