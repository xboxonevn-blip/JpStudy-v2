import 'package:flutter/material.dart';

/// Animated feedback widget for correct/wrong answers
class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String? correctAnswer;
  final String? userAnswer;
  final VoidCallback? onContinue;
  final bool showDetails;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    this.correctAnswer,
    this.userAnswer,
    this.onContinue,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect 
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon and status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Correct!' : 'Incorrect',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!isCorrect && showDetails && correctAnswer != null)
                      Text(
                        'Correct answer: $correctAnswer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          // User's answer (if wrong)
          if (!isCorrect && showDetails && userAnswer != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your answer:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userAnswer!,
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Continue button
          if (onContinue != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple inline feedback indicator
class InlineFeedback extends StatelessWidget {
  final bool isCorrect;
  
  const InlineFeedback({
    super.key,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCorrect ? Icons.check : Icons.close,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isCorrect ? 'Correct' : 'Wrong',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
