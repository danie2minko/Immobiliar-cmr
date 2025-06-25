import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap; 
  final Widget child;
  const MyButton({super.key, required this.onTap, required this.child,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary
        ),
        padding: const EdgeInsets.all(15),
        child: child,
      ),
    );
  }
}