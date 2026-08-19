import 'package:flutter/material.dart';

class HealthKnowledgePage extends StatelessWidget {
  const HealthKnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Santé & Nutrition")),
      body: const Center(child: Text("Espace Santé, Nutrition & Médecine Prophétique")),
    );
  }
}
