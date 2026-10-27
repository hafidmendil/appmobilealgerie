import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/providers/local_care_providers.dart';
import '../../domain/models/protection_models.dart';
import '../providers/protection_providers.dart';

class ProtectionReportPage extends ConsumerStatefulWidget {
  const ProtectionReportPage({super.key});

  @override
  ConsumerState<ProtectionReportPage> createState() =>
      _ProtectionReportPageState();
}

class _ProtectionReportPageState extends ConsumerState<ProtectionReportPage> {
  ReporterMode _mode = ReporterMode.deferred;
  final Set<ViolenceType> _categories = {};
  AnswerValue? _danger;
  ContextType _contextType = ContextType.other;
  final _descriptionController = TextEditingController();
  bool _saving = false;
  bool _localStorageConsent = false;
  String? _consentId;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_categories.isEmpty || _danger == null) return;
    final user = ref.read(currentUserProvider);
    if (_mode == ReporterMode.identified && user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Directionality.of(context) == TextDirection.rtl
                ? 'يجب تسجيل الدخول لهذا الخيار.'
                : 'Connectez-vous pour utiliser ce mode.',
          ),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final rtl = Directionality.of(context) == TextDirection.rtl;
      if (user != null) {
        final consent = await ref
            .read(localCareRepositoryProvider)
            .grantConsent(
              userId: user.id,
              type: 'data_storage',
              purpose: rtl
                  ? 'حفظ مسودة بلاغ محلياً'
                  : 'Conserver localement un brouillon de signalement.',
              dataFields: rtl
                  ? const [
                      'فئات العنف',
                      'مستوى الخطر المصرح به',
                      'السياق',
                      'وصف اختياري',
                    ]
                  : const [
                      'catégories de violence',
                      'niveau de danger déclaré',
                      'contexte',
                      'description facultative',
                    ],
            );
        _consentId = '${consent['id']}';
      }
      final reportId = const Uuid().v4();
      final assessment = ref
          .read(riskEngineProvider)
          .assess(
            id: const Uuid().v4(),
            reportId: reportId,
            answers: {
              'currentDanger': _danger!,
              if (_categories.isNotEmpty) 'nonCritical': AnswerValue.yes,
            },
          );
      final report = ViolenceReport(
        id: reportId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        reporterMode: _mode,
        violenceTypes: _categories.toList(),
        contextType: _contextType,
        occurrencePattern: OccurrencePattern.unknown,
        riskAssessmentId: assessment.id,
        // A local save is not an institutional submission.
        status: ProtectionReportStatus.draft,
        consentVersion: 'protection-consent-1.0',
        confidentialityLevel: 'local-encrypted',
        userId: _mode == ReporterMode.identified ? user!.id : null,
      );
      await ref.read(protectionRepositoryProvider).saveReport(report);
      await ref
          .read(protectionRepositoryProvider)
          .saveRiskAssessment(assessment);
      await ref
          .read(localCareRepositoryProvider)
          .createLocalReport(
            userId: _mode == ReporterMode.identified ? user!.id : null,
            reporterMode: _mode.name,
            violenceTypes: _categories
                .map((category) => category.name)
                .toList(),
            context: _contextType.name,
            severity: assessment.level.name,
            description: _descriptionController.text.trim().isEmpty
                ? (rtl
                      ? 'ملف محلي تم إنشاؤه من نموذج الحماية.'
                      : 'Dossier créé depuis le formulaire de protection.')
                : _descriptionController.text.trim(),
            consentId: _consentId,
          );
      if (!mounted) return;
      context.push('/protection/result', extra: assessment);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final labels = [
      context.l10n.report_mode_anonymous,
      context.l10n.report_mode_identified,
      context.l10n.report_mode_deferred,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.prot_report_situation)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            context.l10n.report_save_draft_notice,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SegmentedButton<ReporterMode>(
            segments: [
              ButtonSegment(
                value: ReporterMode.anonymous,
                label: Text(labels[0]),
              ),
              ButtonSegment(
                value: ReporterMode.identified,
                label: Text(labels[1]),
              ),
              ButtonSegment(
                value: ReporterMode.deferred,
                label: Text(labels[2]),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (values) =>
                setState(() => _mode = values.first),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.report_nature,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ...violenceCategories.map(
            (category) => CheckboxListTile(
              value: _categories.contains(category.id),
              title: Text(rtl ? category.labelAr : category.labelFr),
              subtitle: Text(
                rtl ? category.descriptionAr : category.descriptionFr,
              ),
              onChanged: (selected) => setState(
                () => selected == true
                    ? _categories.add(category.id)
                    : _categories.remove(category.id),
              ),
            ),
          ),
          const Divider(height: 32),
          DropdownButtonFormField<ContextType>(
            value: _contextType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.report_context_label,
              helperText: context.l10n.report_context_helper,
            ),
            items: ContextType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(_contextLabel(type, rtl)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _contextType = value!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLength: 700,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: context.l10n.report_desc_label,
              hintText: context.l10n.report_desc_hint,
              border: const OutlineInputBorder(),
            ),
          ),
          const Divider(height: 32),
          Text(
            context.l10n.report_in_danger,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RadioListTile(
            value: AnswerValue.yes,
            groupValue: _danger,
            title: Text(context.l10n.yes),
            onChanged: (value) => setState(() => _danger = value),
          ),
          RadioListTile(
            value: AnswerValue.no,
            groupValue: _danger,
            title: Text(context.l10n.no),
            onChanged: (value) => setState(() => _danger = value),
          ),
          RadioListTile(
            value: AnswerValue.preferNotToAnswer,
            groupValue: _danger,
            title: Text(context.l10n.prefer_not_to_answer),
            onChanged: (value) => setState(() => _danger = value),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _localStorageConsent,
            onChanged: (value) =>
                setState(() => _localStorageConsent = value ?? false),
            title: Text(context.l10n.report_local_consent_title),
            subtitle: Text(context.l10n.report_local_consent_subtitle),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          FilledButton.icon(
            onPressed:
                _saving ||
                    _categories.isEmpty ||
                    _danger == null ||
                    !_localStorageConsent
                ? null
                : _save,
            icon: const Icon(Icons.lock_outline),
            label: Text(
              _saving ? context.l10n.saving : context.l10n.save_encrypted,
            ),
          ),
        ],
      ),
    );
  }

  String _contextLabel(ContextType type, bool rtl) {
    final labelsFr = {
      ContextType.family: context.l10n.prot_cadre_family,
      ContextType.couple: 'Couple / ex-partenaire',
      ContextType.school: context.l10n.prot_cadre_school,
      ContextType.work: context.l10n.prot_cadre_work,
      ContextType.neighborhood: 'Voisinage / espace public',
      ContextType.online: context.l10n.prot_cadre_online,
      ContextType.other: context.l10n.prot_cadre_other,
    };
    final labelsAr = {
      ContextType.family: context.l10n.prot_cadre_family,
      ContextType.couple: 'الزوج / الشريك السابق',
      ContextType.school: context.l10n.prot_cadre_school,
      ContextType.work: context.l10n.prot_cadre_work,
      ContextType.neighborhood: 'الحي / المكان العام',
      ContextType.online: context.l10n.prot_cadre_online,
      ContextType.other: context.l10n.prot_cadre_other,
    };
    return (rtl ? labelsAr : labelsFr)[type] ?? type.name;
  }
}

class ProtectionResultPage extends StatelessWidget {
  final RiskAssessment assessment;
  const ProtectionResultPage({required this.assessment, super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final immediate = assessment.level == RiskLevel.immediate;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orientation)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              immediate ? Icons.warning_amber : Icons.shield_outlined,
              size: 56,
              color: immediate ? Colors.red : Colors.teal,
            ),
            const SizedBox(height: 16),
            Text(
              immediate
                  ? (rtl
                        ? 'قد تحتاج إلى مساعدة فورية.'
                        : 'Une aide immédiate peut être nécessaire.')
                  : (rtl
                        ? 'يمكنك الاطلاع على موارد موثوقة.'
                        : 'Vous pouvez consulter des ressources vérifiées.'),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              rtl
                  ? 'هذه أولوية توجيهية وليست تشخيصًا أو حكمًا قانونيًا.'
                  : 'Il s’agit d’une priorité indicative d’orientation, jamais d’un diagnostic ni d’un jugement juridique.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => context.push(
                immediate ? '/protection/emergency' : '/orientation/network',
              ),
              icon: Icon(immediate ? Icons.phone_in_talk : Icons.hub_outlined),
              label: Text(
                immediate
                    ? (rtl ? 'المساعدة العاجلة' : 'Aide immédiate')
                    : (rtl
                          ? 'الشركاء والموارد المحلية'
                          : 'Partenaires et ressources locaux'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/protection/safety-plan'),
              icon: const Icon(Icons.checklist_outlined),
              label: Text(context.l10n.prot_safety_plan),
            ),
          ],
        ),
      ),
    );
  }
}
