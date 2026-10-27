import json
import os
import re

fr_arb_path = 'lib/l10n/app_fr.arb'
ar_arb_path = 'lib/l10n/app_ar.arb'

new_keys_fr = {
    "report_nature": "Quelle est la nature de la situation ?",
    "report_in_danger": "Êtes-vous en danger maintenant ?",
    "yes": "Oui",
    "no": "Non",
    "prefer_not_to_answer": "Je préfère ne pas répondre",
    "saving": "Enregistrement...",
    "save_encrypted": "Enregistrer chiffré",
    "orientation": "Orientation",
    "continue_action": "Continuer"
}

new_keys_ar = {
    "report_nature": "ما نوع الوضع؟",
    "report_in_danger": "هل أنت في خطر الآن؟",
    "yes": "نعم",
    "no": "لا",
    "prefer_not_to_answer": "أفضل عدم الإجابة",
    "saving": "جارٍ الحفظ...",
    "save_encrypted": "حفظ بشكل مشفر",
    "orientation": "التوجيه",
    "continue_action": "متابعة"
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
dart_path = 'lib/features/protection/presentation/pages/report_page.dart'
with open(dart_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Make sure L10nExtension is imported
if "import '../../../../core/localization/l10n_extension.dart';" not in content:
    content = content.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';", "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../../../core/localization/l10n_extension.dart';")

replacements = [
    (r"rtl \? 'الإبلاغ عن وضع' : 'Signaler une situation'", "context.l10n.prot_report_situation"),
    (r"rtl \? 'ما نوع الوضع؟' : 'Quelle est la nature de la situation \?'", "context.l10n.report_nature"),
    (r"rtl \? 'هل أنت في خطر الآن؟' : 'Êtes-vous en danger maintenant \?'", "context.l10n.report_in_danger"),
    (r"rtl \? 'نعم' : 'Oui'", "context.l10n.yes"),
    (r"rtl \? 'لا' : 'Non'", "context.l10n.no"),
    (r"rtl \? 'أفضل عدم الإجابة' : 'Je préfère ne pas répondre'", "context.l10n.prefer_not_to_answer"),
    (r"\(rtl \? 'جارٍ الحفظ\.\.\.' : 'Enregistrement\.\.\.'\)", "context.l10n.saving"),
    (r"\(rtl \? 'حفظ بشكل مشفر' : 'Enregistrer chiffré'\)", "context.l10n.save_encrypted"),
    (r"rtl \? 'التوجيه' : 'Orientation'", "context.l10n.orientation"),
    (r"rtl \? 'متابعة' : 'Continuer'", "context.l10n.continue_action")
]

for old, new in replacements:
    content = re.sub(old, new, content)

with open(dart_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done report page")
