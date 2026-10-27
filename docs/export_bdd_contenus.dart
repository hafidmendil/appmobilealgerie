import 'dart:io';

import 'package:projetmascara/features/content/hadith_library.dart';
import 'package:projetmascara/features/content/hikma_library.dart';
import 'package:projetmascara/features/content/quran_library.dart';

void main() {
  _write('docs/AYAT_BDD.txt', _quranText(quranLibrary));
  _write('docs/AHADITH_BDD.txt', _hadithText(hadithLibrary));
  _write('docs/HIKEM_BDD.txt', _hikmaText(hikmaLibrary));

  print(
    'Fichiers créés : docs/AYAT_BDD.txt, docs/AHADITH_BDD.txt, docs/HIKEM_BDD.txt',
  );
  print('Ayat exportés : ${quranLibrary.length}');
  print('Hadiths exportés : ${hadithLibrary.length}');
  print('Hikem exportées : ${hikmaLibrary.length}');
}

String _quranText(Iterable<dynamic> verses) {
  final buffer = StringBuffer('AYAT PRESENTS DANS LA BDD (${verses.length})\n');
  buffer.writeln('====================================');
  for (var index = 0; index < verses.length; index++) {
    final verse = verses.elementAt(index);
    buffer
      ..writeln('\n${index + 1}. ${verse.id}')
      ..writeln('Sourate : ${verse.surahNumber}')
      ..writeln('Verset : ${verse.verseNumber}')
      ..writeln('Theme : ${verse.theme}')
      ..writeln('Arabe : ${verse.textAr}')
      ..writeln('Francais : ${verse.textFr}')
      ..writeln('Contexte : ${verse.context ?? '-'}')
      ..writeln('Reflexion : ${verse.reflection ?? '-'}');
  }
  return buffer.toString();
}

String _hadithText(Iterable<dynamic> hadiths) {
  final buffer = StringBuffer(
    'AHADITH PRESENTS DANS LA BDD (${hadiths.length})\n',
  );
  buffer.writeln('========================================');
  for (var index = 0; index < hadiths.length; index++) {
    final hadith = hadiths.elementAt(index);
    buffer
      ..writeln('\n${index + 1}. ${hadith.id}')
      ..writeln('Collection : ${hadith.collection}')
      ..writeln('Numero : ${hadith.number}')
      ..writeln('Source : ${hadith.source ?? '-'}')
      ..writeln('Theme : ${hadith.theme}')
      ..writeln('Arabe : ${hadith.textAr}')
      ..writeln('Francais : ${hadith.textFr}');
  }
  return buffer.toString();
}

String _hikmaText(Iterable<dynamic> hikem) {
  final buffer = StringBuffer(
    'HIKEM PRESENTES DANS LA BDD (${hikem.length})\n',
  );
  buffer.writeln('=====================================');
  for (var index = 0; index < hikem.length; index++) {
    final hikma = hikem.elementAt(index);
    buffer
      ..writeln('\n${index + 1}. ${hikma.id}')
      ..writeln('Auteur arabe : ${hikma.authorAr ?? '-'}')
      ..writeln('Auteur francais : ${hikma.authorFr ?? '-'}')
      ..writeln('Arabe : ${hikma.textAr}')
      ..writeln('Francais : ${hikma.textFr}')
      ..writeln('Axes : ${hikma.associatedAxes.map(_enumLabel).join(', ')}')
      ..writeln('Etats : ${hikma.associatedStates.map(_enumLabel).join(', ')}');
  }
  return buffer.toString();
}

void _write(String path, String content) {
  File(path).writeAsStringSync(content);
}

String _enumLabel(Object value) {
  final valueText = value.toString();
  final separator = valueText.lastIndexOf('.');
  return separator == -1 ? valueText : valueText.substring(separator + 1);
}
