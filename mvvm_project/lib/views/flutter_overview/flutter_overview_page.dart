import 'package:flutter/material.dart';

const summaryStyle = TextStyle(
  fontSize: 18,
  height: 1.4,
  fontWeight: FontWeight.w600,
  color: Color(0xFF37474F),
);

class FlutterTheoryTopic {
  final String title;
  final String summary;
  final IconData icon;
  final List<String> bullets;

  const FlutterTheoryTopic({
    required this.title,
    required this.summary,
    required this.icon,
    required this.bullets,
  });
}

class FlutterOverviewPage extends StatelessWidget {
  const FlutterOverviewPage({super.key});

  static const List<FlutterTheoryTopic> _topics = [
    FlutterTheoryTopic(
      title: 'Widget',
      summary: 'Stateless/Stateful, build(), lifecycle',
      icon: Icons.widgets,
      bullets: [
        'StatelessWidget dùng khi UI không thay đổi.',
        'StatefulWidget dùng khi UI cần cập nhật.',
        'build() được gọi lại khi state thay đổi.',
        'Lifecycle: initState → build → dispose.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'Layout',
      summary: 'Row/Column/Flex, Stack, GridView',
      icon: Icons.grid_view,
      bullets: [
        'Row và Column sắp xếp widget.',
        'Expanded/Flexible chia tỷ lệ.',
        'Stack để chồng UI.',
        'GridView cho layout dạng lưới.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'Navigation',
      summary: 'Navigator 1.0 / Named routes',
      icon: Icons.alt_route,
      bullets: [
        'Navigator.push mở trang.',
        'Navigator.pop quay lại.',
        'Named routes quản lý route.',
        'Có thể truyền dữ liệu giữa page.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'State',
      summary: 'setState, Provider (ChangeNotifier)',
      icon: Icons.sync_alt,
      bullets: [
        'setState cho widget đơn giản.',
        'Provider cho app lớn.',
        'State nên đặt gần UI sử dụng.',
        'MVVM thường kết hợp Provider.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'Networking',
      summary: 'HTTP, REST API, JSON',
      icon: Icons.cloud_download,
      bullets: [
        'Dùng package http gọi API.',
        'REST API phổ biến trong mobile.',
        'JSON để trao đổi dữ liệu.',
        'FutureBuilder hiển thị dữ liệu async.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'Local DB',
      summary: 'SQLite (sqflite), SharedPreferences',
      icon: Icons.storage,
      bullets: [
        'sqflite lưu dữ liệu dạng bảng.',
        'SharedPreferences lưu key-value.',
        'Dùng cho cache dữ liệu.',
        'Tăng tốc load app.',
      ],
    ),

    FlutterTheoryTopic(
      title: 'UI/UX',
      summary: 'Theme, Material 3, responsive',
      icon: Icons.palette,
      bullets: [
        'Material 3 là design system mới.',
        'Theme giúp đồng bộ màu.',
        'Responsive cho nhiều màn hình.',
        'MediaQuery giúp scale UI.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        title: const Text('Tổng quan Flutter'),
        backgroundColor: const Color(0xFF1E4F9C),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Flutter là framework UI đa nền tảng dùng Dart.\n\n'
                  'Bạn có thể build Android, iOS, Web và Desktop '
                  'từ một codebase duy nhất.',
              style: summaryStyle,
            ),
          ),
          const SizedBox(height: 12),
          ..._topics.map((topic) => _TopicCard(topic: topic)),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final FlutterTheoryTopic topic;

  const _TopicCard({required this.topic});

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlutterTheoryDetailPage(topic: topic),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFEEF5FF),
                child: Icon(topic.icon, color: const Color(0xFF1E88E5)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 28,
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
            colors: [
              Color(0xFFEAF3FF),
              Color(0xFFF8FBFF),
              Colors.white,
            ],
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
                  colors: [
                    Color(0xFF1E88E5),
                    Color(0xFF1565C0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(topic.icon, color: Colors.white, size: 28),
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
              "Nội dung chính",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            ...List.generate(
              topic.bullets.length,
                  (index) => _TheoryPointCard(
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

class _TheoryPointCard extends StatelessWidget {
  final int index;
  final String content;

  const _TheoryPointCard({
    required this.index,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}