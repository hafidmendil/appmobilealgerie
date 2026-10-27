import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_radii.dart';
import '../content/hikma_library.dart';
import '../content/quran_library.dart';
import '../content/hadith_library.dart';
import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../adaptive_assessment/presentation/providers/assessment_provider.dart';
import '../progress/providers/gamification_provider.dart';
import 'dart:math';

class CareCompanionBot extends ConsumerStatefulWidget {
  const CareCompanionBot({super.key});

  @override
  ConsumerState<CareCompanionBot> createState() => _CareCompanionBotState();
}

class _CareCompanionBotState extends ConsumerState<CareCompanionBot> {
  final List<Map<String, dynamic>> _messages = [];
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _messages.add({'role': 'bot', 'content': context.l10n.companionWelcome});
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final text = presetText ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      if (presetText == null) _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Smart triage logic
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      final response = _generateResponse(context, text);

      setState(() {
        _messages.add({'role': 'bot', 'content': response});
        _isTyping = false;
      });

      // Award XP for interacting
      ref.read(gamificationProvider.notifier).addXp(10);
      _scrollToBottom();
    });
  }

  String _generateResponse(BuildContext context, String text) {
    final latestResult = ref.read(latestResultProvider);
    final lowerText = text.toLowerCase();
    final isArabic = context.isRTL;

    // Check for specific keywords first
    if (lowerText.contains('stress') ||
        lowerText.contains('peur') ||
        lowerText.contains('angoisse') ||
        lowerText.contains('توتر') ||
        lowerText.contains('خوف') ||
        lowerText.contains('قلق')) {
      final verse = quranLibrary.firstWhere(
        (v) => v.associatedAxes.contains(AssessmentAxis.stressAnxiety),
        orElse: () => quranLibrary.first,
      );
      final verseText = isArabic ? verse.textAr : verse.textFr;
      return context.l10n.companionStressResponse(verseText);
    }

    if (lowerText.contains('triste') ||
        lowerText.contains('seul') ||
        lowerText.contains('vide') ||
        lowerText.contains('حزين') ||
        lowerText.contains('وحدي') ||
        lowerText.contains('فارغ')) {
      final hikma = hikmaLibrary.firstWhere(
        (h) =>
            h.textFr.toLowerCase().contains('patience') ||
            h.textFr.toLowerCase().contains('espoir'),
        orElse: () => hikmaLibrary.first,
      );
      return context.l10n.companionSadnessResponse(
        isArabic ? hikma.textAr : hikma.textFr,
      );
    }

    // Proactive logic based on assessment results
    if (latestResult != null) {
      if ((latestResult.axisNeeds[AssessmentAxis.sleepEnergy] ?? 0) > 0.6) {
        return context.l10n.companionLowEnergyResponse;
      }
      if ((latestResult.axisNeeds[AssessmentAxis.productivity] ?? 0) > 0.6) {
        return context.l10n.companionFocusResponse;
      }
    }

    // Default response
    final randomHadith = hadithLibrary[Random().nextInt(hadithLibrary.length)];
    return context.l10n.companionDefaultResponse(
      isArabic ? randomHadith.textAr : randomHadith.textFr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(context.l10n.auto_compagnon_neurosync),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isBot = m['role'] == 'bot';
                return _ChatMessage(
                  message: m['content'],
                  isBot: isBot,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.companionThinking,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          _buildSuggestions(context),
          _buildInput(context),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final suggestions = [
      context.l10n.companionSuggestionStress,
      context.l10n.companionSuggestionHope,
      context.l10n.companionSuggestionAdvice,
    ];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: suggestions
            .map(
              (s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ActionChip(
                  label: Text(s),
                  onPressed: () => _handleSend(s),
                  backgroundColor: AppColors.softOlive.withOpacity(0.2),
                  labelStyle: const TextStyle(
                    color: AppColors.oliveGreen,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: context.l10n.writeHereHint,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.largeRadius,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _handleSend(),
              icon: const Icon(
                LucideIcons.send_horizontal,
                color: AppColors.oliveGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final String message;
  final bool isBot;

  const _ChatMessage({required this.message, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey.shade100 : AppColors.oliveGreen,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isBot ? 4 : 16),
            bottomRight: Radius.circular(isBot ? 16 : 4),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isBot ? AppColors.textPrimary : Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
