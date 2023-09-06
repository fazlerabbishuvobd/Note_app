import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/utils/colors.dart';

class ListLeadingDesign extends StatelessWidget {
  const ListLeadingDesign({
    super.key,
    this.colorSerial,
  });

  final int? colorSerial;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: categoryColor[colorSerial!],
        ),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.height,
    required this.width,
    required this.data,
    this.colorSerial,
  });

  final double height;
  final double width;
  final Notes data;
  final int? colorSerial;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: width*0.005,
      top: height*0.008,
      child: Container(
        alignment: Alignment.center,
        height: height*0.028,
        width: width*0.3,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(15),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
          color: categoryColor[colorSerial!],
        ),
        child: Text('${data.category}',style: const TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}