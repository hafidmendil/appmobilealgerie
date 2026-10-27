class StressSupportEngine {
  List<String> getExercises(String langCode) {
    switch (langCode) {
      case 'ar':
        return [
          "تمرين التنفس العميق (4-7-8)",
          "تحديد الأولويات وتقسيم المهام الكبيرة",
          "المشي في الطبيعة لمدة 15 دقيقة",
        ];
      case 'darja':
        return [
          "تفس عميق (طلع النفس واحسب للـ 4 واخرجها للـ 8)",
          "قسم خدمتك لحوايج صغار باش ما تتعبش",
          "أخرج تمشى شوية برا ونحي الضيق",
        ];
      case 'fr':
      default:
        return [
          "Respiration profonde (méthode 4-7-8)",
          "Priorisation et découpage des tâches",
          "Marche en plein air pendant 15 minutes",
        ];
    }
  }
}
