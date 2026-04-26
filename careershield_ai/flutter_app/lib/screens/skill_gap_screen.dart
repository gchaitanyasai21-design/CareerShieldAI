import 'package:flutter/material.dart';

import '../models/skill_gap_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'skill_gap_result_screen.dart';

class SkillGapScreen extends StatefulWidget {
  const SkillGapScreen({super.key});

  @override
  State<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends State<SkillGapScreen> {
  final TextEditingController _skillsController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _selectedRole = AppConstants.availableRoles.first;
  bool _isLoading = false;

  Future<void> _analyze() async {
    final skills = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    if (skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one skill.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.analyzeSkillGap(
        userSkills: skills,
        targetRole: _selectedRole,
      );
      final result = SkillGapModel.fromMap(response);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SkillGapResultScreen(
            result: result,
            userSkills: skills,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Gap Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Measure your readiness',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your current skills, choose your target role, and get a learning roadmap.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(labelText: 'Target Role'),
              items: AppConstants.availableRoles
                  .map(
                    (role) => DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _skillsController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Current Skills',
                hintText: 'Example: Python, SQL, Excel, Flutter, Firebase',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Separate each skill with a comma.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Analyze Skill Gap',
              onPressed: _analyze,
              isLoading: _isLoading,
              icon: Icons.auto_graph_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
