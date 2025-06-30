// ignore: file_names
import 'package:flutter/material.dart';

class BackGestureWrapper extends StatelessWidget {
  final Widget child;

  const BackGestureWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Ensures back navigation is possible
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context); // Swipe right to go back
          }
        },
        child: child,
      ),
    );
  }
}
