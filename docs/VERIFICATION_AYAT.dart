import 'package:projetmascara/features/content/quran_library.dart';

void main() {
  print('AYAT A VERIFIER (${quranLibrary.length})');
  print('='.padRight(80, '='));

  for (var index = 0; index < quranLibrary.length; index++) {
    final verse = quranLibrary[index];
    print('\n${index + 1}. ${verse.id}');
    print('Sourate   : ${verse.surahNumber}');
    print('Verset    : ${verse.verseNumber}');
    print('Contexte  : ${verse.context ?? '-'}');
    print('Theme     : ${verse.theme}');
    print('Arabe     : ${verse.textAr}');
    print('Francais  : ${verse.textFr}');
    print('Reflexion : ${verse.reflection ?? '-'}');
    print(
      'Axes      : ${verse.associatedAxes.map((axis) => axis.name).join(', ')}',
    );
  }
}
