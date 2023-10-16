import 'package:first_guide/domain/objects/quiz.dart';
import 'package:first_guide/ui/quiz_box.dart';
import 'package:first_guide/ui/result_box.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late Quiz quiz = Quiz();
  late ResultDescriptor resultDescriptor = quiz.resultDescriptor();
  late QuestionDescriptor questionDescriptor = quiz.questionDescriptor();

  @override
  void initState() {
    super.initState();

    quiz.observe(this, (rDescriptor, qDescriptor) {
      setState(() {
        resultDescriptor = rDescriptor;
        questionDescriptor = qDescriptor;
      });
    });

    quiz.start(15);
  }

  @override
  void dispose() {
    quiz.unObserve(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (resultDescriptor.isQuizFinished) {
      body = ResultBox(resultDescriptor.percentageScore, () => quiz.start(15));
    } else {
      body = QuizBox(questionDescriptor.question, questionDescriptor.options,
          (String answer) => quiz.answerCurrentAndGoToNext(answer));
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: body,
      ),
    );
  }
}
