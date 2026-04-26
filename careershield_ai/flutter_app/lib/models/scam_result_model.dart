class ScamResultModel {
  final String verdict;
  final double riskScore;
  final List<String> redFlags;
  final List<String> positiveSignals;
  final String explanation;
  final String recommendation;
  final String scamType;
  final double mlConfidence;
  final bool isScam;

  ScamResultModel({
    required this.verdict,
    required this.riskScore,
    required this.redFlags,
    required this.positiveSignals,
    required this.explanation,
    required this.recommendation,
    required this.scamType,
    required this.mlConfidence,
    required this.isScam,
  });

  factory ScamResultModel.fromMap(Map<String, dynamic> map) {
    return ScamResultModel(
      verdict: (map['verdict'] ?? 'UNKNOWN') as String,
      riskScore: ((map['risk_score'] ?? 0) as num).toDouble(),
      redFlags: List<String>.from(map['red_flags'] ?? const []),
      positiveSignals: List<String>.from(map['positive_signals'] ?? const []),
      explanation: (map['explanation'] ?? '') as String,
      recommendation: (map['recommendation'] ?? '') as String,
      scamType: (map['scam_type'] ?? 'Unknown') as String,
      mlConfidence: ((map['ml_confidence'] ?? 0) as num).toDouble(),
      isScam: (map['is_scam'] ?? false) as bool,
    );
  }
}
