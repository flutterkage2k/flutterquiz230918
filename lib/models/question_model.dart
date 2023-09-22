class QuestionModel {
  final String text;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  QuestionModel({
    required this.text,
    required this.options,
    this.isLocked = false,
    this.selectedOption,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  Option({
    required this.text,
    required this.isCorrect,
  });
}

final Questions = [
  QuestionModel(
    text: '문제 1',
    options: [
      Option(
        text: 'a',
        isCorrect: false,
      ),
      Option(
        text: 'b',
        isCorrect: false,
      ),
      Option(
        text: 'c',
        isCorrect: false,
      ),
      Option(
        text: 'd',
        isCorrect: true,
      )
    ],
  ),
  QuestionModel(
    text: '문제 2',
    options: [
      Option(
        text: 'a',
        isCorrect: false,
      ),
      Option(
        text: 'b',
        isCorrect: false,
      ),
      Option(
        text: 'c',
        isCorrect: false,
      ),
      Option(
        text: 'd',
        isCorrect: true,
      )
    ],
  )
];
