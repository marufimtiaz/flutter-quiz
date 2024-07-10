import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(const Quiz());

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal.shade800,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctAnswer = 0;
  // List<String> questions = [
  //   'You can lead a cow down stairs but not up stairs.',
  //   'Approximately one quarter of human bones are in the feet.',
  //   'A slug\'s blood is green.',
  // ];
  // List<bool> answers = [
  //   false,
  //   true,
  //   true,
  // ];
  // Question q1 = Question(
  //     q: 'You can lead a cow down stairs but not up stairs.', a: false);

  // List<Question> questionList = [
  //   Question('You can lead a cow down stairs but not up stairs.', false),
  //   Question('Approximately one quarter of human bones are in the feet.', true),
  //   Question('A slug\'s blood is green.', true)
  // ];
  QuizBrain quizBrain = QuizBrain();
  // int questionNumber = 0;
  void alertChoice() {
    if (correctAnswer > scoreKeeper.length / 2) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "CONGRATULATIONS",
        desc: "You had $correctAnswer correct answers!",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "Try Again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "OH NO!",
        desc: "You had only $correctAnswer correct answers!",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "Try Again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  void checkAnswer(bool userAnswer) {
    setState(() {
      if (quizBrain.isFinished) {
        alertChoice();
        quizBrain.resetquestionNumber();
        scoreKeeper.clear();
        correctAnswer = 0;
      } else {
        if (quizBrain.getCorrectAnswer() == userAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
          correctAnswer++;
        } else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        quizBrain.nextQuestion();
      }
    });
  }

  void reset() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              onPressed: () {
                checkAnswer(true);
              },
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              onPressed: () {
                checkAnswer(false);
              },
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
