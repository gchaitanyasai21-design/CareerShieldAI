class AppConstants {
  static const String appName = 'CareerShield AI';
  static const String appTagline =
      'Securing Opportunities, Empowering Ambitions';
  static const String appVersion = '1.0.0';

  static const String fnDetectScam = 'detectScam';
  static const String fnSkillGap = 'analyzeSkillGap';
  static const String fnHistory = 'getUserHistory';
  static const String fnDashboard = 'getDashboardStats';

  static const String colUsers = 'users';
  static const String colScamChecks = 'scam_checks';
  static const String colSkillChecks = 'skill_checks';

  static const List<String> availableRoles = [
    'Data Analyst',
    'Machine Learning Engineer',
    'Flutter App Developer',
    'Web Developer',
    'Data Scientist',
    'Cloud Engineer',
    'Cybersecurity Analyst',
    'UI/UX Designer',
  ];

  static const int minJobTextLength = 50;
}
