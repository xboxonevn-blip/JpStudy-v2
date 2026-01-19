import 'package:flutter/material.dart';

import '../../learn/models/question_type.dart';
import '../models/test_session.dart';
import '../services/test_export_service.dart';

class TestResultsScreen extends StatelessWidget {
  final TestSession session;

  const TestResultsScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            onSelected: (value) => _handleExport(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: ListTile(
                  leading: Icon(Icons.copy),
                  title: Text('Copy to Clipboard'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share Results'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Grade circle
              _buildGradeCircle(context),
              const SizedBox(height: 32),

              // Score summary
              _buildScoreSummary(context),
              const SizedBox(height: 32),

              // Stats grid
              _buildStatsGrid(context),
              const SizedBox(height: 32),

              // XP Card
              _buildXPCard(context),
              const SizedBox(height: 32),

              // Type breakdown
              _buildTypeBreakdown(context),
              const SizedBox(height: 32),

              // Weak terms
              if (session.weakTermIds.isNotEmpty) ...[
                _buildWeakTermsCard(context),
                const SizedBox(height: 32),
              ],

              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeCircle(BuildContext context) {
    final gradeColor = _getGradeColor(session.grade);

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradeColor, gradeColor.withValues(alpha: 0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: gradeColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          session.grade,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSummary(BuildContext context) {
    return Column(
      children: [
        Text(
          '${session.score.toInt()}%',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${session.correctCount} of ${session.totalQuestions} correct',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            value: session.correctCount,
            label: 'Correct',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.cancel,
            value: session.wrongCount,
            label: 'Wrong',
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.timer,
            value: _formatDuration(session.timeElapsed),
            label: 'Time',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildXPCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Text(
            '+${session.xpEarned} XP',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBreakdown(BuildContext context) {
    final breakdown = session.breakdownByType;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance by Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...breakdown.entries.map((entry) => _buildTypeRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildTypeRow(QuestionType type, TypeBreakdown breakdown) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(type.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: LinearProgressIndicator(
                      value: breakdown.accuracy / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        breakdown.accuracy >= 70 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${breakdown.correct}/${breakdown.total}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakTermsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.priority_high, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                '${session.weakTermIds.length} terms need practice',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Review these terms to improve your score.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.visibility),
            label: const Text(
              'Review Answers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  void _handleExport(BuildContext context, String action) async {
    switch (action) {
      case 'copy':
        await TestExportService.copyToClipboard(session);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Results copied to clipboard!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;
      case 'share':
        await TestExportService.shareResults(session);
        break;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final dynamic value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
