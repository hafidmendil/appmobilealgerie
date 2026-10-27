import 'package:projetmascara/features/content/hadith_library.dart';

void main() {
  print('HADITHS A VERIFIER (${hadithLibrary.length})');
  print('='.padRight(80, '='));

  for (var index = 0; index < hadithLibrary.length; index++) {
    final hadith = hadithLibrary[index];
    print('\n${index + 1}. ${hadith.id}');
    print('Collection : ${hadith.collection}');
    print('Numero    : ${hadith.number}');
    print('Source    : ${hadith.source ?? '-'}');
    print('Theme     : ${hadith.theme}');
    print('Arabe     : ${hadith.textAr}');
    print('Francais  : ${hadith.textFr}');
    print(
      'Axes      : ${hadith.associatedAxes.map((axis) => axis.name).join(', ')}',
    );
  }
}
