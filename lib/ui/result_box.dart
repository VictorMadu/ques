import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final String percentageScore;
  final VoidCallback restartHandler;

  const ResultBox(this.percentageScore, this.restartHandler, {super.key});

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
                onPressed: () => restartHandler(),
                child: const Text('Restart')))
      ],
    );
  }
}
