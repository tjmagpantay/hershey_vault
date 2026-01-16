import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  const GifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'GIF Section\nComing Soon',
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
