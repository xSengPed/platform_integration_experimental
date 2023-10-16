import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.green[700],
          elevation: 0,
        ),
        onPressed: onPressed,
        child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: child),
      ),
    );
  }
}
