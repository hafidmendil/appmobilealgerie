import json
import os

fr_arb_path = 'lib/l10n/app_fr.arb'
ar_arb_path = 'lib/l10n/app_ar.arb'

new_keys_fr = {
    "local_reports_title": "Mes signalements locaux",
    "local_reports_empty": "Aucun signalement enregistré.",
    "local_report_item": "Signalement enregistré localement",
    "safety_plan_title": "Plan de sécurité local",
    "safety_plan_subtitle": "Un plan court et prudent",
    "safety_plan_warning": "N’enregistrez aucune information qui pourrait vous mettre en danger si l’appareil est partagé.",
    "safety_plan_reach_safe": "Rejoindre un lieu sûr",
    "safety_plan_contact_trust": "Contacter une personne de confiance",
    "safety_plan_delete": "Supprimer le plan de l’appareil",
    "voice_analysis_title": "Analyse vocale intelligente",
    "voice_analysis_confidential": "Ce test est confidentiel et automatisé. Votre voix n’est enregistrée sur aucun serveur externe.",
    "voice_analysis_language": "Langue d'expression :",
    "voice_analysis_instruction": "Appuyez sur le micro et parlez pendant 5 à 10 secondes",
    "voice_analysis_analyzing": "Analyse des biomarqueurs vocaux...",
    "voice_analysis_completed": "Analyse complétée !",
    "voice_analysis_ready": "Prêt à enregistrer",
    "voice_analysis_results_title": "Résultats du pré-diagnostic vocal",
    "voice_analysis_transcription": "Transcription (Darja/STT) :",
    "voice_analysis_stress_index": "Indice de stress",
    "voice_analysis_emotional_state": "État émotionnel",
    "voice_analysis_vocal_stability": "Stabilité vocale",
    "voice_analysis_recommendation": "Recommandation : Votre voix indique un stress modéré. Nous vous conseillons de faire un exercice de respiration ou de consulter un psychologue partenaire.",
    "voice_analysis_prefer_write": "Vous préférez écrire ?",
    "voice_analysis_write_hint": "Décrivez ce que vous ressentez ici...",
    "voice_analysis_save_note": "Enregistrer la note",
    "voice_analysis_note_saved": "Note enregistrée avec succès."
}

new_keys_ar = {
    "local_reports_title": "بلاغاتي المحلية",
    "local_reports_empty": "لا توجد بلاغات محفوظة.",
    "local_report_item": "بلاغ محفوظ محليًا",
    "safety_plan_title": "خطة أمان محلية",
    "safety_plan_subtitle": "خطة مختصرة وآمنة",
    "safety_plan_warning": "لا تحفظ هنا أي معلومة قد تعرضك للخطر إذا كان الجهاز مشتركًا.",
    "safety_plan_reach_safe": "الوصول إلى مكان آمن",
    "safety_plan_contact_trust": "التواصل مع شخص موثوق",
    "safety_plan_delete": "حذف الخطة من الجهاز",
    "voice_analysis_title": "الفحص الصوتي الذكي (الدّارجة)",
    "voice_analysis_confidential": "هذا الفحص سرّي وتلقائي بالكامل. لا يتم حفظ صوتك على أي خادم خارجي حمايةً لخصوصيتك.",
    "voice_analysis_language": "اختر لغة التعبير الحالية :",
    "voice_analysis_instruction": "انقر على الميكروفون وتحدث لمدة 5 إلى 10 ثوانٍ",
    "voice_analysis_analyzing": "جاري فحص مؤشرات الصوت...",
    "voice_analysis_completed": "اكتمل التحليل!",
    "voice_analysis_ready": "جاهز للتسجيل",
    "voice_analysis_results_title": "نتائج الفحص الصوتي المبدئي",
    "voice_analysis_transcription": "النص المكتوب (Darja/STT) :",
    "voice_analysis_stress_index": "مؤشر الإجهاد",
    "voice_analysis_emotional_state": "الحالة الانفعالية",
    "voice_analysis_vocal_stability": "مستوى الاستقرار الصوتي",
    "voice_analysis_recommendation": "نصيحة التوجيه المسبق : نبرتك توحي بوجود ضغط أو إرهاق عصبي متوسط. نوصي بتجربة تمرين التنفس أو استشارة معالج نفسي شريك عبر المنصة.",
    "voice_analysis_prefer_write": "هل تفضل الكتابة ؟",
    "voice_analysis_write_hint": "اكتب ما تشعر به هنا بشكل اختياري...",
    "voice_analysis_save_note": "حفظ الملاحظة محلياً",
    "voice_analysis_note_saved": "تم حفظ الملاحظة بنجاح."
}

def update_arb(path, new_keys):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data.update(new_keys)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_arb(fr_arb_path, new_keys_fr)
update_arb(ar_arb_path, new_keys_ar)

# Replace in dart file
dart_path = 'lib/features/protection/presentation/pages/local_tools_pages.dart'
with open(dart_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Make sure L10nExtension is imported
if "import '../../../../core/localization/l10n_extension.dart';" not in content:
    content = content.replace("import '../../domain/models/protection_models.dart';", "import '../../domain/models/protection_models.dart';\nimport '../../../../core/localization/l10n_extension.dart';")

replacements = [
    (r"rtl \? 'بلاغاتي المحلية' : 'Mes signalements locaux'", "context.l10n.local_reports_title"),
    (r"rtl\n                    \? 'لا توجد بلاغات محفوظة.'\n                    : 'Aucun signalement enregistré.'", "context.l10n.local_reports_empty"),
    (r"rtl\n                      \? 'بلاغ محفوظ محليًا'\n                      : 'Signalement enregistré localement'", "context.l10n.local_report_item"),
    (r"rtl \? 'خطة أمان محلية' : 'Plan de sécurité local'", "context.l10n.safety_plan_title"),
    (r"rtl \? 'خطة مختصرة وآمنة' : 'Un plan court et prudent'", "context.l10n.safety_plan_subtitle"),
    (r"rtl\n                \? 'لا تحفظ هنا أي معلومة قد تعرضك للخطر إذا كان الجهاز مشتركًا.'\n                : 'N’enregistrez aucune information qui pourrait vous mettre en danger si l’appareil est partagé.'", "context.l10n.safety_plan_warning"),
    (r"rtl \? 'الوصول إلى مكان آمن' : 'Rejoindre un lieu sûr'", "context.l10n.safety_plan_reach_safe"),
    (r"rtl\n                  \? 'التواصل مع شخص موثوق'\n                  : 'Contacter une personne de confiance'", "context.l10n.safety_plan_contact_trust"),
    (r"rtl \? 'حذف الخطة من الجهاز' : 'Supprimer le plan de l’appareil'", "context.l10n.safety_plan_delete"),
    (r"rtl\n        \? 'الفحص الصوتي الذكي \(الدّارجة\)'\n        : 'Analyse vocale intelligente'", "context.l10n.voice_analysis_title"),
    (r"rtl\n                            \? 'هذا الفحص سرّي وتلقائي بالكامل\. لا يتم حفظ صوتك على أي خادم خارجي حمايةً لخصوصيتك\.'\n                            : 'Ce test est confidentiel et automatisé\. Votre voix n’est enregistrée sur aucun serveur externe\.'", "context.l10n.voice_analysis_confidential"),
    (r"rtl \? 'اختر لغة التعبير الحالية :' : 'Langue d\'expression :'", "context.l10n.voice_analysis_language"),
    (r"rtl\n                          \? 'انقر على الميكروفون وتحدث لمدة 5 إلى 10 ثوانٍ'\n                          : 'Appuyez sur le micro et parlez pendant 5 à 10 secondes'", "context.l10n.voice_analysis_instruction"),
    (r"rtl\n                            \? 'جاري فحص مؤشرات الصوت\.\.\.'\n                            : 'Analyse des biomarqueurs vocaux\.\.\.'", "context.l10n.voice_analysis_analyzing"),
    (r"\(rtl \? 'اكتمل التحليل!' : 'Analyse complétée !'\)", "context.l10n.voice_analysis_completed"),
    (r"\(rtl \? 'جاهز للتسجيل' : 'Prêt à enregistrer'\)", "context.l10n.voice_analysis_ready"),
    (r"rtl\n                    \? 'نتائج الفحص الصوتي المبدئي'\n                    : 'Résultats du pré-diagnostic vocal'", "context.l10n.voice_analysis_results_title"),
    (r"rtl\n                            \? 'النص المكتوب \(Darja/STT\) :'\n                            : 'Transcription \(Darja/STT\) :'", "context.l10n.voice_analysis_transcription"),
    (r"rtl \? 'مؤشر الإجهاد' : 'Indice de stress'", "context.l10n.voice_analysis_stress_index"),
    (r"rtl\n                                  \? 'الحالة الانفعالية'\n                                  : 'État émotionnel'", "context.l10n.voice_analysis_emotional_state"),
    (r"rtl \? 'مستوى الاستقرار الصوتي' : 'Stabilité vocale'", "context.l10n.voice_analysis_vocal_stability"),
    (r"rtl\n                            \? 'نصيحة التوجيه المسبق : نبرتك توحي بوجود ضغط أو إرهاق عصبي متوسط\. نوصي بتجربة تمرين التنفس أو استشارة معالج نفسي شريك عبر المنصة\.'\n                            : 'Recommandation : Votre voix indique un stress modéré\. Nous vous conseillons de faire un exercice de respiration ou de consulter un psychologue partenaire\.'", "context.l10n.voice_analysis_recommendation"),
    (r"rtl \? 'هل تفضل الكتابة ؟' : 'Vous préférez écrire \?'", "context.l10n.voice_analysis_prefer_write"),
    (r"rtl\n                    \? 'اكتب ما تشعر به هنا بشكل اختياري\.\.\.'\n                    : 'Décrivez ce que vous ressentez ici\.\.\.'", "context.l10n.voice_analysis_write_hint"),
    (r"rtl \? 'حفظ الملاحظة محلياً' : 'Enregistrer la note'", "context.l10n.voice_analysis_save_note"),
    (r"rtl\n                          \? 'تم حفظ الملاحظة بنجاح\.'\n                          : 'Note enregistrée avec succès\.'", "context.l10n.voice_analysis_note_saved")
]

import re
for old, new in replacements:
    content = re.sub(old, new, content)

# Remove 'final rtl = Directionality.of(context) == TextDirection.rtl;'
content = re.sub(r"\s*final rtl = Directionality\.of\(context\) == TextDirection\.rtl;\n", "\n", content)
content = re.sub(r"\s*final rtl = Directionality\.of\(context\) == TextDirection\.rtl;\s*final title = context\.l10n\.voice_analysis_title;\n", "\n    final title = context.l10n.voice_analysis_title;\n", content)

with open(dart_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done")
