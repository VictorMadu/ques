import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final String percentageScore;
  final VoidCallback onRestartPressed;

  const ResultBox(
      {required this.percentageScore,
      required this.onRestartPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Your Score is $percentageScore',
            style: const TextStyle(fontSize: 32),
          ),
        ),
        Center(
            child: ElevatedButton(
                onPressed: onRestartPressed, child: const Text('Restart')))
      ],
    );
  }
}
