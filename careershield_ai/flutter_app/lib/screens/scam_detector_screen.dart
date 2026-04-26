import 'package:flutter/material.dart';

import '../models/scam_result_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'scam_result_screen.dart';

class ScamDetectorScreen extends StatefulWidget {
  const ScamDetectorScreen({super.key});

  @override
  State<ScamDetectorScreen> createState() => _ScamDetectorScreenState();
}

class _ScamDetectorScreenState extends State<ScamDetectorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _analyze() async {
    final text = _controller.text.trim();

    if (text.length < AppConstants.minJobTextLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please paste a longer job description to analyze.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.detectScam(text);
      final result = ScamResultModel.fromMap(response);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScamResultScreen(
            result: result,
            originalText: text,
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scam Detector')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste a job or internship listing',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We will score the risk, explain the red flags, and recommend a safer next step.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText:
                      'Paste the full job description, recruiter message, salary claim, links, and contact details here...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Analyze Job Posting',
              onPressed: _analyze,
              isLoading: _isLoading,
              icon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }
}
