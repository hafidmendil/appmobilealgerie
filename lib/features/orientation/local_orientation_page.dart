import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/providers/local_care_providers.dart';
import '../../core/services/local_care_repository.dart';

/// Local orientation only.  It recommends verified records stored on this
/// device and never shares an assessment or report without a new consent.
class LocalOrientationPage extends ConsumerStatefulWidget {
  const LocalOrientationPage({super.key});

  @override
  ConsumerState<LocalOrientationPage> createState() =>
      _LocalOrientationPageState();
}

class _LocalOrientationPageState extends ConsumerState<LocalOrientationPage> {
  String _specialty = 'psychologist';
  String _situation = 'vulnerability';
  String _riskLevel = 'moderate';
  bool _loading = false;
  List<LocalPartnerMatch>? _matches;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _text(
            isArabic,
            'Orientation et réseau local',
            'التوجيه والشبكة المحلية',
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _notice(isArabic),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _situation,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: _text(isArabic, 'Votre situation', 'وضعيتك'),
              ),
              items: [
                DropdownMenuItem(
                  value: 'vulnerability',
                  child: Text(
                    _text(
                      isArabic,
                      'Vulnérabilité / bien-être',
                      'هشاشة أو رفاه',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'victim',
                  child: Text(
                    _text(
                      isArabic,
                      'Personne exposée à la violence',
                      'شخص معرّض للعنف',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'actor',
                  child: Text(
                    _text(
                      isArabic,
                      'Colère, conflit ou comportement préoccupant',
                      'غضب أو نزاع أو سلوك مقلق',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'witness',
                  child: Text(
                    _text(
                      isArabic,
                      'Témoin recherchant de l’aide',
                      'شاهد يبحث عن مساعدة',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _situation = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _specialty,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: _text(
                  isArabic,
                  'Besoin principal',
                  'الحاجة الرئيسية',
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'psychologist',
                  child: Text(
                    _text(isArabic, 'Psychologue', 'أخصائي نفسي'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'psychiatrist',
                  child: Text(
                    _text(isArabic, 'Psychiatre', 'طبيب نفسي'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'neurologist',
                  child: Text(
                    _text(isArabic, 'Neurologue', 'طبيب أعصاب'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'healthProfessional',
                  child: Text(
                    _text(isArabic, 'Professionnel de santé', 'مهني صحي'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'socialWorker',
                  child: Text(
                    _text(isArabic, 'Travailleur social', 'أخصائي اجتماعي'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'legalSupport',
                  child: Text(
                    _text(
                      isArabic,
                      'Information/orientation juridique',
                      'معلومات أو توجيه قانوني',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'association',
                  child: Text(
                    _text(isArabic, 'Association', 'جمعية'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _specialty = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _riskLevel,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: _text(
                  isArabic,
                  'Niveau de besoin déclaré',
                  'مستوى الحاجة المصرّح به',
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'low',
                  child: Text(
                    _text(
                      isArabic,
                      'Information et prévention',
                      'معلومات ووقاية',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'moderate',
                  child: Text(
                    _text(
                      isArabic,
                      'Accompagnement recommandé',
                      'مرافقة موصى بها',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Text(
                    _text(isArabic, 'Besoin prioritaire', 'حاجة ذات أولوية'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'urgent',
                  child: Text(
                    _text(
                      isArabic,
                      'Danger ou urgence — utiliser les services officiels',
                      'خطر أو حالة طارئة — استخدم الخدمات الرسمية',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _riskLevel = value!),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loading ? null : () => _search(user?.wilayaId),
              icon: const Icon(Icons.manage_search),
              label: Text(
                _text(
                  isArabic,
                  'Chercher des partenaires vérifiés',
                  'البحث عن شركاء موثوقين',
                ),
              ),
            ),
            if (user != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push('/orientation/my-requests'),
                icon: const Icon(Icons.bookmark_outline),
                label: Text(
                  _text(
                    isArabic,
                    'Voir mes orientations enregistrées',
                    'عرض توجيهاتي المحفوظة',
                  ),
                ),
              ),
            ],
            if (_riskLevel == 'urgent') ...[
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.warning_amber_rounded),
                  title: Text(
                    _text(
                      isArabic,
                      'Ne vous fiez pas à l’annuaire pour une urgence',
                      'لا تعتمد على الدليل في حالة طارئة',
                    ),
                  ),
                  subtitle: Text(
                    _text(
                      isArabic,
                      'Mettez votre sécurité en priorité et utilisez les services d’urgence officiels ou une personne de confiance.',
                      'اجعل سلامتك أولوية واستخدم خدمات الطوارئ الرسمية أو تواصل مع شخص موثوق.',
                    ),
                  ),
                  onTap: () => context.push('/protection/emergency'),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_matches != null) _results(user?.id, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _notice(bool isArabic) => Card(
    color: Colors.blue.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _text(
          isArabic,
          'Mode local-first : seules les fiches vérifiées présentes sur cet appareil peuvent être proposées. Cette recherche ne partage aucune donnée. Une mise en relation restera locale jusqu’à votre consentement explicite.',
          'وضع محلي أولاً: لا يمكن اقتراح سوى الملفات الموثقة الموجودة على هذا الجهاز. لا يشارك هذا البحث أي بيانات، وتبقى الإحالة محلية حتى تمنح موافقتك الصريحة.',
        ),
      ),
    ),
  );

  Widget _results(String? userId, bool isArabic) {
    if (_matches!.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _text(
              isArabic,
              'Aucun partenaire vérifié ne correspond actuellement. Consultez les ressources, élargissez votre recherche, ou utilisez les canaux officiels si votre sécurité est en jeu.',
              'لا يوجد حالياً شريك موثوق مطابق. راجع الموارد أو وسّع بحثك أو استخدم القنوات الرسمية إذا كانت سلامتك معرضة للخطر.',
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic
              ? '${_matches!.length} شريك/شركاء موثوقون'
              : '${_matches!.length} partenaire(s) vérifié(s)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ..._matches!.map(
          (match) => Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.health_and_safety_outlined),
              ),
              title: Text('${match.partner['name']}'),
              subtitle: Text(
                [
                  '${_specialtyLabel('${match.partner['specialty']}', isArabic)} · ${isArabic ? 'ولاية' : 'Wilaya'} ${match.partner['wilayaId']}',
                  ...match.reasons,
                  if (match.partner['contact']?.toString().isNotEmpty == true)
                    '${isArabic ? 'الاتصال' : 'Contact'}: ${match.partner['contact']}',
                ].join('\n'),
              ),
              isThreeLine: true,
              trailing: userId == null
                  ? Tooltip(
                      message: _text(
                        isArabic,
                        'Connectez-vous pour enregistrer une mise en relation',
                        'سجّل الدخول لحفظ طلب الإحالة',
                      ),
                      child: Icon(Icons.lock_outline),
                    )
                  : IconButton(
                      tooltip: _text(
                        isArabic,
                        'Demander une mise en relation locale',
                        'طلب إحالة محلية',
                      ),
                      icon: const Icon(Icons.handshake_outlined),
                      onPressed: () =>
                          _requestReferral(userId, '${match.partner['id']}'),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _search(String? wilaya) async {
    setState(() {
      _loading = true;
      _matches = null;
    });
    final matches = await ref
        .read(localCareRepositoryProvider)
        .matchPartners(
          specialty: _specialty,
          situation: _situation,
          riskLevel: _riskLevel,
          wilayaId: wilaya,
          language: Localizations.localeOf(context).languageCode,
        );
    if (mounted)
      setState(() {
        _loading = false;
        _matches = matches;
      });
  }

  Future<void> _requestReferral(String userId, String partnerId) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _text(
            isArabic,
            'Consentement à la mise en relation',
            'الموافقة على الإحالة',
          ),
        ),
        content: Text(
          _text(
            isArabic,
            'NeuroSync enregistrera localement votre choix et le motif d’orientation. Aucune donnée ne sera envoyée au partenaire dans cette version locale.',
            'سيسجل NeuroSync اختيارك وسبب الإحالة محلياً. لن تُرسل أي بيانات إلى الشريك في هذه النسخة المحلية.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_text(isArabic, 'Annuler', 'إلغاء')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_text(isArabic, 'Je consens', 'أوافق')),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    try {
      final repo = ref.read(localCareRepositoryProvider);
      final consent = await repo.grantConsent(
        userId: userId,
        type: 'partner_referral',
        purpose: 'Conserver localement une demande de mise en relation',
        dataFields: const ['motif', 'wilaya'],
        recipientId: partnerId,
      );
      await repo.createReferral(
        userId: userId,
        partnerId: partnerId,
        reason: 'Orientation $_situation / $_specialty',
        consentId: '${consent['id']}',
      );
      ref.invalidate(localReferralsProvider(userId));
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _text(
                isArabic,
                'Mise en relation enregistrée localement.',
                'تم تسجيل الإحالة محلياً.',
              ),
            ),
          ),
        );
    } on StateError catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  String _text(bool isArabic, String french, String arabic) =>
      isArabic ? arabic : french;

  String _specialtyLabel(String value, bool isArabic) {
    return switch (value) {
      'psychologist' => _text(isArabic, 'Psychologue', 'أخصائي نفسي'),
      'psychiatrist' => _text(isArabic, 'Psychiatre', 'طبيب نفسي'),
      'neurologist' => _text(isArabic, 'Neurologue', 'طبيب أعصاب'),
      'healthProfessional' => _text(
        isArabic,
        'Professionnel de santé',
        'مهني صحي',
      ),
      'socialWorker' => _text(isArabic, 'Travailleur social', 'أخصائي اجتماعي'),
      'legalSupport' => _text(
        isArabic,
        'Orientation juridique',
        'توجيه قانوني',
      ),
      'association' => _text(isArabic, 'Association', 'جمعية'),
      _ => value,
    };
  }
}
