import 'package:flutter/material.dart';

class CarousselImg extends StatelessWidget {
  final String path;
  const CarousselImg({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade200),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Image.asset(path, fit: BoxFit.cover,),
      ),
    );
  }
}
