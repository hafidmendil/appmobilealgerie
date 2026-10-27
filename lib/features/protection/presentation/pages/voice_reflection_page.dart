import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../core/data/hive_config.dart';

/// A truthful offline alternative to voice analysis.
///
/// This application has no local speech-recognition or clinical voice model.
/// It must therefore never manufacture a transcript, emotion or stress score.
/// The page provides a private speaking exercise and optional encrypted notes.
class VoiceReflectionPage extends StatefulWidget {
  const VoiceReflectionPage({super.key});

  @override
  State<VoiceReflectionPage> createState() => _VoiceReflectionPageState();
}

class _VoiceReflectionPageState extends State<VoiceReflectionPage> {
  static const _exerciseDuration = 60;

  final _noteController = TextEditingController();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _exerciseRunning = false;

  Box<dynamic> get _notesBox => Hive.box<dynamic>(HiveConfig.voiceNotesBox);

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  List<MapEntry<dynamic, Map<String, dynamic>>> get _notes {
    final notes = _notesBox.keys
        .map(
          (key) => MapEntry(
            key,
            Map<String, dynamic>.from(_notesBox.get(key) as Map),
          ),
        )
        .where((entry) => entry.value['type'] == 'voice_reflection_note')
        .toList();
    notes.sort(
      (a, b) => '${b.value['createdAt']}'.compareTo('${a.value['createdAt']}'),
    );
    return notes;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleExercise() {
    if (_exerciseRunning) {
      _timer?.cancel();
      setState(() => _exerciseRunning = false);
      return;
    }

    setState(() {
      _elapsedSeconds = 0;
      _exerciseRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_elapsedSeconds >= _exerciseDuration - 1) {
        timer.cancel();
        setState(() {
          _elapsedSeconds = _exerciseDuration;
          _exerciseRunning = false;
        });
        return;
      }
      setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _saveNote() async {
    final content = _noteController.text.trim();
    if (content.isEmpty) return;

    final now = DateTime.now().toUtc();
    await _notesBox.put('voice_note_${now.microsecondsSinceEpoch}', {
      'type': 'voice_reflection_note',
      'content': content,
      'createdAt': now.toIso8601String(),
      'audioCaptured': false,
      'analysisPerformed': false,
    });
    _noteController.clear();
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isArabic
              ? 'تم حفظ الملاحظة محليًا على هذا الجهاز.'
              : 'La note est enregistrée localement sur cet appareil.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arabic = _isArabic;
    final notes = _notes;
    final remaining = _exerciseDuration - _elapsedSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Text(arabic ? 'تمرين صوتي خاص' : 'Exercice vocal privé'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          arabic
                              ? 'لا يوجد تحليل أو تسجيل صوتي'
                              : 'Aucune analyse ni capture vocale',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    arabic
                        ? 'هذه النسخة المحلية لا تطلب إذن الميكروفون، ولا تسجل أو تنسخ أو تشخّص الصوت. لا يمكن للصوت وحده قياس التوتر أو الحالة النفسية بشكل موثوق.'
                        : 'Cette version locale ne demande pas le microphone, n’enregistre pas, ne transcrit pas et ne diagnostique pas la voix. La voix seule ne permet pas de mesurer de façon fiable le stress ou l’état psychologique.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            arabic ? 'تمرين لمدة دقيقة' : 'Exercice d’une minute',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            arabic
                ? 'إن رغبت، تحدث بصوت مسموع لنفسك عن ما تحتاجه الآن: الأمان، الراحة، المساندة أو الخطوة التالية. يمكنك التوقف في أي وقت.'
                : 'Si vous le souhaitez, exprimez à voix haute, pour vous-même, ce dont vous avez besoin maintenant : sécurité, repos, soutien ou prochaine étape. Vous pouvez arrêter à tout moment.',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '00:${remaining.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _toggleExercise,
                    icon: Icon(
                      _exerciseRunning
                          ? Icons.stop_circle_outlined
                          : Icons.play_arrow,
                    ),
                    label: Text(
                      _exerciseRunning
                          ? (arabic ? 'إيقاف التمرين' : 'Arrêter l’exercice')
                          : (arabic ? 'بدء التمرين' : 'Démarrer l’exercice'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            arabic ? 'ملاحظة شخصية اختيارية' : 'Note personnelle facultative',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            arabic
                ? 'لا تكتب أسماء أو عناوين أو معلومات قد تعرّف بك إذا كنت تستعمل جهازًا مشتركًا.'
                : 'N’écrivez ni nom, ni adresse, ni élément identifiable si vous utilisez un appareil partagé.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 4,
            maxLength: 700,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: arabic
                  ? 'ما الذي تريد تذكره لنفسك؟'
                  : 'Que souhaitez-vous retenir pour vous-même ?',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _saveNote,
            icon: const Icon(Icons.lock_outline),
            label: Text(arabic ? 'حفظ محلي مشفّر' : 'Enregistrer localement'),
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              arabic ? 'ملاحظات هذا الجهاز' : 'Notes de cet appareil',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...notes.map((entry) {
              final note = entry.value;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text('${note['content']}'),
                  subtitle: Text(
                    arabic
                        ? 'لم يُسجّل أي صوت ولم يُجرَ أي تحليل.'
                        : 'Aucun son n’a été enregistré ni analysé.',
                  ),
                  trailing: IconButton(
                    tooltip: arabic ? 'حذف' : 'Supprimer',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await _notesBox.delete(entry.key);
                      if (mounted) setState(() {});
                    },
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
