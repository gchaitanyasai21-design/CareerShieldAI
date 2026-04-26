import 'package:flutter/material.dart';

import '../utils/colors.dart';

class RiskBarWidget extends StatelessWidget {
  final double riskScore;

  const RiskBarWidget({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getRiskColor(riskScore);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Risk Score',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${riskScore.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (riskScore / 100).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
