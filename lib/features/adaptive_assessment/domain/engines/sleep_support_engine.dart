class SleepSupportEngine {
  List<String> getAdvice(String langCode) {
    switch (langCode) {
      case 'ar':
        return [
          "تجنب الشاشات قبل ساعة من النوم",
          "تثبيت وقت النوم والاستيقاظ",
          "جعل غرفة النوم هادئة ومظلمة",
        ];
      case 'darja':
        return [
          "نحي التيليفون ساعة قبل ما ترقد",
          "حاول ترقد وتنوض في نفس الوقت كل يوم",
          "دير لبلاصة لي ترقد فيها هادية ومافيهاش الضو",
        ];
      case 'fr':
      default:
        return [
          "Éviter les écrans une heure avant le coucher",
          "Maintenir des horaires de sommeil réguliers",
          "Créer un environnement calme et sombre",
        ];
    }
  }
}
