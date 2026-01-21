import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Reset Database Utility Widget
/// Call this from Settings or Debug menu
class DatabaseResetDialog extends StatelessWidget {
  const DatabaseResetDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const DatabaseResetDialog(),
    );
  }

  static Future<bool> resetDatabase() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'jpstudy.sqlite'));
      
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error resetting database: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Database'),
      content: const Text(
        'This will DELETE ALL your progress, including:\n'
        '• Learned terms\n'
        '• SRS review data\n'
        '• Custom term edits\n'
        '• Stars and bookmarks\n\n'
        'The app will restart with fresh data.\n\n'
        'Are you sure?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            final success = await resetDatabase();
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? '✅ Database reset! Please restart the app.'
                        : '⚠️ Database not found or already deleted.',
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
          child: const Text('Delete All Data'),
        ),
      ],
    );
  }
}
