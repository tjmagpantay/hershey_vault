import 'package:flutter/material.dart';

class MemePage extends StatelessWidget {
  const MemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Meme Section\nComing Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white70,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
