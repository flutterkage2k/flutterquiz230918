import 'package:flutter/material.dart';
import 'package:flutterquizgetx230918/models/question_model.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;
  late PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 32,
            ),
            Text('Question $_questionNumber / ${Questions.length}'),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: PageView.builder(
                itemCount: Questions.length,
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final _question = Questions[index];
                  return buildQuestion(_question);
                },
              ),
            ),
            _isLocked ? buildElevatedButton() : SizedBox.shrink(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Column buildQuestion(QuestionModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 32,
        ),
        Text(
          question.text,
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(
          height: 32,
        ),
        Expanded(
          child: OptionsWidget(
            question: question,
            onClickedOption: (Option value) {
              if (question.isLocked) {
                return;
              } else {
                setState(() {
                  question.isLocked = true;
                  question.selectedOption = value;
                });
                _isLocked = question.isLocked;
                if (question.selectedOption!.isCorrect) {
                  _score++;
                }
              }
            },
          ),
        ),
      ],
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        if (_questionNumber < Questions.length) {
          _controller.nextPage(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
            _isLocked = false;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(score: _score),
            ),
          );
        }
      },
      child: Text(
        _questionNumber < Questions.length ? 'Next' : 'See the Result',
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final QuestionModel question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget(
      {super.key, required this.question, required this.onClickedOption});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: question.options
            .map(
              (option) => buildOption(context, option),
            )
            .toList(),
      ),
    );
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);

    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        height: 50,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.text,
              style: TextStyle(fontSize: 20),
            ),
            getIconForOption(option, question),
          ],
        ),
      ),
    );
  }

  Widget getIconForOption(Option option, QuestionModel question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.cancel,
                color: Colors.red,
              );
      } else if (option.isCorrect) {
        return Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }
    }
    return SizedBox.shrink();
  }

  Color getColorForOption(Option option, QuestionModel question) {
    final isSelected = option == question.selectedOption;

    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('당신은 이번에 정답수 $score / 총 문제 수 :${Questions.length}')),
    );
  }
}
