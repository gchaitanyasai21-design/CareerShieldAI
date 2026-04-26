import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _apiService.getUserHistory();
  }

  String _formatTimestamp(dynamic value) {
    if (value == null) return 'Unknown time';
    try {
      final date = DateTime.parse(value.toString());
      return DateFormat.yMMMd().add_jm().format(date);
    } catch (_) {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My History')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? {};
          final scamHistory = data['scamHistory'] as List<dynamic>? ?? [];
          final skillHistory = data['skillHistory'] as List<dynamic>? ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Scam Checks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (scamHistory.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No scam checks yet.'),
                  ),
                )
              else
                ...scamHistory.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item['verdict']?.toString() ?? 'Unknown'),
                      subtitle: Text(item['explanation']?.toString() ?? ''),
                      trailing: Text(_formatTimestamp(item['timestamp'])),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Skill Checks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (skillHistory.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No skill gap checks yet.'),
                  ),
                )
              else
                ...skillHistory.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item['targetRole']?.toString() ?? 'Role'),
                      subtitle:
                          Text('Match Score: ${item['matchScore'] ?? 0}%'),
                      trailing: Text(_formatTimestamp(item['timestamp'])),
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
