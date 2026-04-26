import 'package:cloud_functions/cloud_functions.dart';

class ApiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> detectScam(String jobText) async {
    try {
      final callable = _functions.httpsCallable('detectScam');
      final result = await callable.call({'jobText': jobText});
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Scam detection failed');
    }
  }

  Future<Map<String, dynamic>> analyzeSkillGap({
    required List<String> userSkills,
    required String targetRole,
  }) async {
    try {
      final callable = _functions.httpsCallable('analyzeSkillGap');
      final result = await callable.call({
        'userSkills': userSkills,
        'targetRole': targetRole,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Skill gap analysis failed');
    }
  }

  Future<Map<String, dynamic>> getUserHistory() async {
    try {
      final callable = _functions.httpsCallable('getUserHistory');
      final result = await callable.call();
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch history');
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final callable = _functions.httpsCallable('getDashboardStats');
      final result = await callable.call();
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch dashboard');
    }
  }
}
