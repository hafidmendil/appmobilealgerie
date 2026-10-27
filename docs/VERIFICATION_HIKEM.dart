import 'package:projetmascara/features/content/hikma_library.dart';

void main() {
  print('HIKEM A VERIFIER (${hikmaLibrary.length})');
  print('='.padRight(80, '='));

  for (var index = 0; index < hikmaLibrary.length; index++) {
    final hikma = hikmaLibrary[index];
    print('\n${index + 1}. ${hikma.id}');
    print('Auteur arabe     : ${hikma.authorAr ?? '-'}');
    print('Auteur francais  : ${hikma.authorFr ?? '-'}');
    print('Arabe            : ${hikma.textAr}');
    print('Francais         : ${hikma.textFr}');
    print(
      'Axes             : ${hikma.associatedAxes.map((axis) => axis.name).join(', ')}',
    );
    print(
      'Etats            : ${hikma.associatedStates.map((state) => state.name).join(', ')}',
    );
  }
}
