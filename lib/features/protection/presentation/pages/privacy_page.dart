import 'package:flutter/material.dart';

class ProtectionPrivacyPage extends StatelessWidget {
  const ProtectionPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(title: Text(rtl ? 'الخصوصية' : 'Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            rtl
                ? 'بياناتك الحساسة تخزن محليًا بشكل مشفر عند الإمكان.'
                : 'Les données sensibles sont stockées localement et chiffrées lorsque cela est possible.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            rtl
                ? 'يمكنك اختيار الإبلاغ المجهول أو المؤجل. لا يتم إنشاء معرف مستخدم للإبلاغ المجهول. لا تطلب التطبيق عنوانًا دقيقًا افتراضيًا.'
                : 'Vous pouvez choisir un signalement anonyme ou différé. Aucun identifiant utilisateur n’est créé pour un signalement anonyme. L’adresse exacte n’est pas demandée par défaut.',
          ),
          const SizedBox(height: 16),
          Text(
            rtl
                ? 'انتبه إلى مخاطر الجهاز المشترك، ويمكنك حذف سجلك المحلي.'
                : 'Un appareil partagé peut présenter un risque. Vous pouvez supprimer votre dossier local.',
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rtl
                        ? 'المرجع القانوني المحلي'
                        : 'Références juridiques locales',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rtl
                        ? 'قانون 18-07 المؤرخ في 10 يونيو 2018 يحمي البيانات ذات الطابع الشخصي، ومنها بيانات الصحة والحالة النفسية. لهذا لا يتم حفظ البيانات الحساسة إلا بموافقة صريحة، ولا ترسل هذه النسخة المحلية أي بيانات تلقائيًا.'
                        : 'La loi n° 18-07 du 10 juin 2018 protège les données à caractère personnel, y compris les informations de santé et de situation psychologique. C’est pourquoi les données sensibles ne sont conservées qu’avec un accord explicite et ne sont jamais envoyées automatiquement par cette version locale.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rtl
                        ? 'قانون الصحة رقم 18-11 وقواعد السر المهني تفرضان مراجعة بشرية من المؤسسة المختصة قبل استعمال التطبيق في متابعة طبية أو نفسية فعلية.'
                        : 'La loi n° 18-11 relative à la santé et le secret professionnel imposent une revue humaine par l’institution compétente avant tout usage pour un suivi médical ou psychologique réel.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
