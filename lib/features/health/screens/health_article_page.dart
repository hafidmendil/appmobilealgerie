import 'package:flutter/material.dart';

class HealthArticlePage extends StatelessWidget {
  final String articleId;
  const HealthArticlePage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Article")),
      body: Center(child: Text("Détails de l'article $articleId")),
    );
  }
}
