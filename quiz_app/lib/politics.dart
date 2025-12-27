import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PoliticsPage extends StatefulWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  _PoliticsPageState createState() => _PoliticsPageState();
}

class _PoliticsPageState extends State<PoliticsPage> {
  List questions = [];
  int? selectedIndex;
  bool isanswered = false;
  int currentequestionindex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    final response = await http.get(
      Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=24&difficulty=easy&type=multiple',
      ),
    );

    final data = jsonDecode(response.body);

    setState(() {
      questions = data['results'];
    });
  }

  List<String> getOptions(Map question) {
    List<String> options = List<String>.from(question['incorrect_answers']);
    options.add(question['correct_answer']);
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentequestionindex >= questions.length) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Quiz completed')),
        body: Column(
          children: [
            Center(
              child: Text(
                'You have attempted all the questions',
                style: TextStyle(fontSize: 20, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                'Your Score is : $score',
                style: TextStyle(fontSize: 20, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text('Retry')),
          ],
        ),
      );
    }

    final question = questions[currentequestionindex];
    final options = getOptions(question);
    final correctanswer = question['correct_answer'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Quiz app',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontSize: 15, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: isanswered
                        ? null
                        : () {
                            setState(() {
                              selectedIndex = index;
                              isanswered = true;
                            });

                            if (options[index] == correctanswer) {
                              score++;
                            }

                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                currentequestionindex++;
                                selectedIndex = null;
                                isanswered = false;
                              });
                            });
                          },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: isanswered
                            ? (index == selectedIndex &&
                                    options[index] == correctanswer)
                                ? Colors.green
                                : (index == selectedIndex &&
                                        options[index] != correctanswer)
                                    ? Colors.red
                                    : Colors.blueGrey
                            : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          options[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
