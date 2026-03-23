import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/flutter_overview/flutter_theory_topic.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_icon_mapper.dart';
import 'package:mvvm_project/views/flutter_overview/widgets/theory_point_card.dart';

class FlutterTheoryDetailPage extends StatelessWidget {
  final FlutterTheoryTopic topic;

  const FlutterTheoryDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: const Color(0xFF1E4F9C),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF3FF), Color(0xFFF8FBFF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    flutterTopicIcon(topic.iconName),
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      topic.summary,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Lý thuyết chi tiết',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...topic.theory.map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nội dung chính',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            ...List.generate(
              topic.bullets.length,
              (index) => TheoryPointCard(
                index: index,
                content: topic.bullets[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
