import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String text;

  const Answer(this.text, this.selectHandler, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectHandler,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 0, 255, 1)),
        child: Text(
          text,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
