import 'package:first_guide/domain/objects/quiz.dart';
import 'package:test/test.dart';

void main() {
  group('Quiz', () {
    test('Process', () {
      final quiz = Quiz();

      ResultDescriptor resultDescriptor;
      QuestionDescriptor questionDescriptor;

      resultDescriptor = quiz.resultDescriptor();

      expect(resultDescriptor.isQuizFinished, false);

      quiz.start(2);

      for (var i = 0; i < 2; i++) {
        questionDescriptor = quiz.questionDescriptor();
        quiz.answerCurrentAndGoToNext(questionDescriptor.options[0]);
      }

      resultDescriptor = quiz.resultDescriptor();
      expect(resultDescriptor.isQuizFinished, true);

      quiz.start(10);

      resultDescriptor = quiz.resultDescriptor();
      expect(resultDescriptor.isQuizFinished, false);

      for (var i = 0; i < 10; i++) {
        questionDescriptor = quiz.questionDescriptor();
        quiz.answerCurrentAndGoToNext(questionDescriptor.options[0]);
      }

      resultDescriptor = quiz.resultDescriptor();
      expect(resultDescriptor.isQuizFinished, true);
    });
  });
}
