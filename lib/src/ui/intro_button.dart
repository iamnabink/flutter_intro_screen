import 'package:flutter/material.dart';

class IntroButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const IntroButton({Key? key,  this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: child,
    );
  }
}
