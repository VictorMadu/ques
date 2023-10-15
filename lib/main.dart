import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var questionIndex = 0;

    var questions = [
      "What's your favourite color?",
      "What's your favourite animal?"
    ];

    void answerQuestion() {
      questionIndex++;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My First App'),
        ),
        body: Column(
          children: <Widget>[
            Text(questions[questionIndex]),
            ElevatedButton(
              onPressed: () => print('Answer 1 chosen'),
              child: const Text('Answer 1'),
            ),
            ElevatedButton(
              onPressed: () => print('Answer 2 chosen'),
              child: const Text('Answer 2'),
            ),
            ElevatedButton(
              onPressed: () => print('Answer 3 chosen'),
              child: const Text('Answer 3'),
            ),
          ],
        ),
      ),
    );
  }
}
