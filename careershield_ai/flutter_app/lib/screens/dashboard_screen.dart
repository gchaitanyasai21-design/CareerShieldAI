import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _apiService.getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? {};
          final stats = data['platformStats'] as Map<String, dynamic>? ?? {};
          final skills = data['trendingSkills'] as List<dynamic>? ?? [];
          final roles = data['availableRoles'] as List<dynamic>? ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Scams Detected',
                      value: '${stats['totalScamsDetected'] ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Students Protected',
                      value: '${stats['studentsProtected'] ?? 0}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Trending Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...skills.map(
                (item) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Text('${item['rank']}'),
                    ),
                    title: Text(item['skill']?.toString() ?? ''),
                    subtitle:
                        Text('Demand score: ${item['demand_score'] ?? 0}'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Roles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...roles.map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item['role']?.toString() ?? ''),
                    subtitle: Text(
                      '${item['demand_level']} • ${item['salary_inr']}',
                    ),
                    trailing: Text('${item['demand_score']}'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
