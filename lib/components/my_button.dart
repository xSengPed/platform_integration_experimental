import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;

  const MyButton({super.key, required this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          elevation: 0,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
