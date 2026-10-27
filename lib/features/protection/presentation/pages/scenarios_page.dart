import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:projetmascara/features/protection/domain/engines/protection_exercises.dart';

class ProtectionScenariosPage extends StatefulWidget {
  const ProtectionScenariosPage({super.key});
  @override
  State<ProtectionScenariosPage> createState() =>
      _ProtectionScenariosPageState();
}

class _ProtectionScenariosPageState extends State<ProtectionScenariosPage> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final scenario = InteractiveScenarioEngine.scenarios.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.scenarios_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            rtl ? scenario.textAr : scenario.textFr,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...scenario.options.map(
            (option) => RadioListTile<String>(
              value: option.textFr,
              groupValue: selected,
              title: Text(rtl ? option.textAr : option.textFr),
              onChanged: (value) => setState(() => selected = value),
            ),
          ),
          if (selected != null)
            Text(
              context.l10n.scenarios_selection_notice,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }
}
