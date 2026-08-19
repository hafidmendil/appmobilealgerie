import 'package:flutter/material.dart';

class HealthQuizPage extends StatelessWidget {
  final String quizId;
  const HealthQuizPage({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Center(child: Text("Quiz de progression $quizId")),
    );
  }
}
