class SkillGapModel {
  final String targetRole;
  final int matchScore;
  final String readiness;
  final String readinessMessage;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> niceToHave;
  final String avgSalaryInr;
  final String avgSalaryUsd;
  final String demandLevel;
  final int demandScore;
  final String growthRate;
  final List<String> topCompanies;
  final String description;
  final int totalRequired;
  final int skillsAcquired;
  final int skillsRemaining;
  final Map<String, dynamic>? learningPath;

  SkillGapModel({
    required this.targetRole,
    required this.matchScore,
    required this.readiness,
    required this.readinessMessage,
    required this.matchedSkills,
    required this.missingSkills,
    required this.niceToHave,
    required this.avgSalaryInr,
    required this.avgSalaryUsd,
    required this.demandLevel,
    required this.demandScore,
    required this.growthRate,
    required this.topCompanies,
    required this.description,
    required this.totalRequired,
    required this.skillsAcquired,
    required this.skillsRemaining,
    required this.learningPath,
  });

  factory SkillGapModel.fromMap(Map<String, dynamic> map) {
    return SkillGapModel(
      targetRole: (map['target_role'] ?? '') as String,
      matchScore: (map['match_score'] ?? 0) as int,
      readiness: (map['readiness'] ?? '') as String,
      readinessMessage: (map['readiness_message'] ?? '') as String,
      matchedSkills: List<String>.from(map['matched_skills'] ?? const []),
      missingSkills: List<String>.from(map['missing_skills'] ?? const []),
      niceToHave: List<String>.from(map['nice_to_have'] ?? const []),
      avgSalaryInr: (map['avg_salary_inr'] ?? '') as String,
      avgSalaryUsd: (map['avg_salary_usd'] ?? '') as String,
      demandLevel: (map['demand_level'] ?? '') as String,
      demandScore: (map['demand_score'] ?? 0) as int,
      growthRate: (map['growth_rate'] ?? '') as String,
      topCompanies: List<String>.from(map['top_companies'] ?? const []),
      description: (map['description'] ?? '') as String,
      totalRequired: (map['total_required'] ?? 0) as int,
      skillsAcquired: (map['skills_acquired'] ?? 0) as int,
      skillsRemaining: (map['skills_remaining'] ?? 0) as int,
      learningPath: map['learning_path'] as Map<String, dynamic>?,
    );
  }
}
