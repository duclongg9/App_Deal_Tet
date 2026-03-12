import 'package:flutter/services.dart';
import 'package:mvvm_project/data/interfaces/repositories/ifutter_overview_repository.dart';
import 'package:mvvm_project/domain/entities/flutter_overview/flutter_theory_topic.dart';

class FlutterOverviewRepository implements IFlutterOverviewRepository {
  static const _assetPath = 'assets/content/flutter_theory_topics.md';

  @override
  Future<List<FlutterTheoryTopic>> getTopics() async {
    final raw = await rootBundle.loadString(_assetPath);
    final sections = raw.split('\n===\n').map((e) => e.trim()).where((e) => e.isNotEmpty);

    return sections.map(_parseTopic).toList();
  }

  FlutterTheoryTopic _parseTopic(String section) {
    final lines = section.split('\n');

    String title = '';
    String summary = '';
    String iconName = 'help';

    final theory = <String>[];
    final bullets = <String>[];

    _ContentMode mode = _ContentMode.none;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      if (trimmed.startsWith('## ')) {
        title = trimmed.replaceFirst('## ', '').trim();
        continue;
      }

      if (trimmed.startsWith('icon:')) {
        iconName = trimmed.replaceFirst('icon:', '').trim();
        continue;
      }

      if (trimmed.startsWith('summary:')) {
        summary = trimmed.replaceFirst('summary:', '').trim();
        continue;
      }

      if (trimmed == '### Theory') {
        mode = _ContentMode.theory;
        continue;
      }

      if (trimmed == '### Bullets') {
        mode = _ContentMode.bullets;
        continue;
      }

      if (!trimmed.startsWith('- ')) {
        continue;
      }

      final content = trimmed.replaceFirst('- ', '').trim();
      if (mode == _ContentMode.theory) {
        theory.add(content);
      } else if (mode == _ContentMode.bullets) {
        bullets.add(content);
      }
    }

    return FlutterTheoryTopic(
      title: title,
      summary: summary,
      iconName: iconName,
      theory: theory,
      bullets: bullets,
    );
  }
}

enum _ContentMode { none, theory, bullets }
