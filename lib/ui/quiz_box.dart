import 'package:flutter/material.dart';

class QuizBox extends StatelessWidget {
  final String question;
  final List<String> options;
  final void Function(String answer) answerSelectedHandler;

  const QuizBox(this.question, this.options, this.answerSelectedHandler,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _Question(question),
          ...options.map((option) => _Option(option, answerSelectedHandler))
        ],
      ),
    );
  }
}

class _Question extends StatelessWidget {
  final String question;

  const _Question(this.question);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String option;
  final void Function(String answer) answerSelectedHandler;

  const _Option(this.option, this.answerSelectedHandler);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => answerSelectedHandler(option),
          child: Text(option),
        ),
      ),
    );
  }
}
