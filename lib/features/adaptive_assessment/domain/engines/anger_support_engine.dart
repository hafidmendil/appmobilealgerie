class AngerSupportEngine {
  List<String> getTechniques(String langCode) {
    switch (langCode) {
      case 'ar':
        return [
          "تمرين 'التوقف' عند الشعور بالغضب",
          "التعبير عن المشاعر بالكتابة",
          "العد التنازلي من 10 قبل الرد"
        ];
      case 'darja':
        return [
          "احبس كلش كي تحس روحك راح تطرطق",
          "أكتب واش راك حاس في ورقة",
          "أحسب للـ 10 قبل ما تهدر ولا تدير أي حاجة"
        ];
      case 'fr':
      default:
        return [
          "Technique du 'Time-out' immédiat",
          "Exprimer ses émotions par l'écriture",
          "Compter jusqu'à 10 avant de réagir"
        ];
    }
  }
}
