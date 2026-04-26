import 'package:flutter/material.dart';

import '../models/scam_result_model.dart';
import '../utils/colors.dart';
import '../widgets/red_flag_card.dart';
import '../widgets/risk_bar_widget.dart';

class ScamResultScreen extends StatelessWidget {
  final ScamResultModel result;
  final String originalText;

  const ScamResultScreen({
    super.key,
    required this.result,
    required this.originalText,
  });

  @override
  Widget build(BuildContext context) {
    final verdictColor = AppColors.getVerdictColor(result.verdict);

    return Scaffold(
      appBar: AppBar(title: const Text('Scam Analysis Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: verdictColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: verdictColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.verified_user_rounded, color: verdictColor, size: 42),
                  const SizedBox(height: 12),
                  Text(
                    result.verdict,
                    style: TextStyle(
                      color: verdictColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.scamType,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RiskBarWidget(riskScore: result.riskScore),
                    const SizedBox(height: 14),
                    Text(
                      'ML Confidence: ${result.mlConfidence.toStringAsFixed(1)}%',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Why this result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  result.explanation,
                  style: const TextStyle(height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Red Flags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (result.redFlags.isEmpty)
              const Text('No explicit red flags were returned.')
            else
              ...result.redFlags.map((flag) => RedFlagCard(text: flag)),
            const SizedBox(height: 20),
            const Text(
              'Positive Signals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (result.positiveSignals.isEmpty)
              const Text('No strong positive signals were identified.')
            else
              ...result.positiveSignals.map(
                (signal) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                  title: Text(signal),
                ),
              ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Action',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.recommendation,
                      style: const TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
