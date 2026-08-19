import 'package:flutter/material.dart';

class HealthAdminScreen extends StatelessWidget {
  const HealthAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Connaissances")),
      body: const Center(child: Text("Interface d'administration Santé")),
    );
  }
}
