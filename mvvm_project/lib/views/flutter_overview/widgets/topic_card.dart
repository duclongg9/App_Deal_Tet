import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/flutter_overview/flutter_theory_topic.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_icon_mapper.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_overview_styles.dart';

class TopicCard extends StatelessWidget {
  final FlutterTheoryTopic topic;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFEEF5FF),
                child: Icon(
                  flutterTopicIcon(topic.iconName),
                  color: const Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(topic.summary, style: summaryStyle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF90A4AE)),
            ],
          ),
        ),
      ),
    );
  }
}
