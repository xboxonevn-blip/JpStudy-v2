import 'package:flutter/material.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Exam')),
      body: const Center(
        child: Text('Mock exam flow will live here.'),
      ),
    );
  }
}
