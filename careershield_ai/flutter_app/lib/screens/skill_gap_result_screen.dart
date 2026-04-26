import 'package:flutter/material.dart';

import '../models/skill_gap_model.dart';
import '../utils/colors.dart';
import '../widgets/skill_chip.dart';

class SkillGapResultScreen extends StatelessWidget {
  final SkillGapModel result;
  final List<String> userSkills;

  const SkillGapResultScreen({
    super.key,
    required this.result,
    required this.userSkills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Gap Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.targetRole,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(result.description, style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: result.matchScore / 100,
                      minHeight: 12,
                      color: AppColors.success,
                      backgroundColor: AppColors.success.withOpacity(0.15),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Match Score: ${result.matchScore}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.readiness} • ${result.readinessMessage}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _StatGrid(result: result),
            const SizedBox(height: 20),
            const Text(
              'Matched Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: result.matchedSkills
                  .map(
                    (skill) => SkillChip(
                      label: skill,
                      backgroundColor: AppColors.success.withOpacity(0.12),
                      foregroundColor: AppColors.success,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Missing Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: result.missingSkills
                  .map(
                    (skill) => SkillChip(
                      label: skill,
                      backgroundColor: AppColors.danger.withOpacity(0.1),
                      foregroundColor: AppColors.danger,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Learning Roadmap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...(result.learningPath?['roadmap'] as List<dynamic>? ?? const [])
                .map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.12),
                        child: Text('${item['month']}'),
                      ),
                      title: Text(item['skill']?.toString() ?? 'Skill'),
                      subtitle: Text(
                        '${item['resource']}\n${item['milestone']}',
                        style: const TextStyle(height: 1.5),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final SkillGapModel result;

  const _StatGrid({required this.result});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _StatCard(title: 'Salary', value: result.avgSalaryInr),
        _StatCard(title: 'Demand', value: result.demandLevel),
        _StatCard(title: 'Growth', value: result.growthRate),
        _StatCard(title: 'Top Companies', value: result.topCompanies.join(', ')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
