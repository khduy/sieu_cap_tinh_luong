import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/constant/constant.dart';
import '../../utils/common_func.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key}) : super(key: key);

  Future<void> _exportAndShareLogs(List<String> logs) async {
    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final fileName = 'logs_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File('${directory.path}/$fileName');

      // Write logs to file
      await file.writeAsString(logs.join('\n'));

      // Share file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Application Logs',
      );
    } catch (e, stackTrace) {
      log('Failed to export logs: $e', stacktrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final logs = Hive.box<String>(kLogBoxName).values.toList();
              _exportAndShareLogs(logs);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear logs?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Hive.box<String>(kLogBoxName).clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<String>>(
        valueListenable: Hive.box<String>(kLogBoxName).listenable(),
        builder: (context, box, _) {
          final logs = box.values.toList().reversed.toList();

          if (logs.isEmpty) {
            return const Center(
              child: Text('No logs available'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  log,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
