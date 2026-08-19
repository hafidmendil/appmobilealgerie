import 'package:flutter/material.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/widgets/sind_components.dart';
import '../../content/hikma_library.dart';
import 'dart:math';

class CareCompanionBot extends StatefulWidget {
  const CareCompanionBot({super.key});

  @override
  State<CareCompanionBot> createState() => _CareCompanionBotState();
}

class _CareCompanionBotState extends State<CareCompanionBot> {
  final List<Map<String, String>> _messages = [
    {'role': 'bot', 'content': 'Bonjour ! Je suis votre compagnon NeuroSync. Comment vous sentez-vous aujourd\'hui ?'}
  ];
  final _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': _controller.text});
      _controller.clear();
      
      // Rule-based response
      Future.delayed(const Duration(milliseconds: 600), () {
        final randomHikma = hikmaLibrary[Random().nextInt(hikmaLibrary.length)];
        setState(() {
          _messages.add({
            'role': 'bot', 
            'content': 'Je comprends. Gardez cette sagesse à l\'esprit : "${randomHikma.textFr}"'
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Compagnon NeuroSync")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isBot = m['role'] == 'bot';
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? Colors.grey.shade200 : AppColors.softOlive,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Text(m['content']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Écrivez ici..."),
                  ),
                ),
                IconButton(onPressed: _handleSend, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
