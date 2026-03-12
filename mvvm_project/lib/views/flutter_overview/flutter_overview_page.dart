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
      summary: 'Mọi thứ trong Flutter đều là Widget.',
      icon: Icons.widgets,
      bullets: [
        'StatelessWidget dùng cho UI không thay đổi theo trạng thái.',
        'StatefulWidget dùng khi giao diện cần cập nhật dữ liệu động.',
        'Hàm build() được gọi lại khi state thay đổi để vẽ lại giao diện.',
        'Lifecycle cơ bản: createState → initState → build → dispose.',
      ],
    ),
    FlutterTheoryTopic(
      title: 'Layout',
      summary: 'Sắp xếp UI bằng các widget bố cục linh hoạt.',
      icon: Icons.dashboard_customize,
      bullets: [
        'Row và Column để xếp phần tử theo chiều ngang hoặc dọc.',
        'Expanded/Flexible để chia tỷ lệ không gian trong Row/Column.',
        'Stack để chồng nhiều lớp giao diện lên nhau.',
        'GridView phù hợp danh sách dạng lưới (ảnh, sản phẩm, thẻ).',
      ],
    ),
    FlutterTheoryTopic(
      title: 'Navigation',
      summary: 'Điều hướng giữa các màn hình bằng Navigator.',
      icon: Icons.alt_route,
      bullets: [
        'Navigator.push() mở màn hình mới trên stack.',
        'Navigator.pop() quay về màn hình trước đó.',
        'Named routes giúp quản lý route tập trung, dễ bảo trì.',
        'Có thể truyền dữ liệu qua constructor hoặc arguments khi điều hướng.',
      ],
    ),
    FlutterTheoryTopic(
      title: 'State',
      summary: 'Quản lý trạng thái để UI luôn đồng bộ dữ liệu.',
      icon: Icons.sync_alt,
      bullets: [
        'setState() phù hợp bài toán nhỏ, cập nhật nhanh trong 1 widget.',
        'ChangeNotifier + Provider phù hợp app vừa/lớn, tách UI và logic.',
        'State nên đặt gần nơi sử dụng để giảm rebuild không cần thiết.',
        'MVVM thường kết hợp Provider để quản lý state rõ ràng.',
      ],
    ),
    FlutterTheoryTopic(
      title: 'Networking',
      summary: 'Lấy dữ liệu từ server qua HTTP/REST API.',
      icon: Icons.cloud_download,
      bullets: [
        'Dùng package http hoặc dio để gọi API GET/POST/PUT/DELETE.',
        'JSON được parse thành model để dùng an toàn trong Dart.',
        'Cần xử lý loading, error, timeout để UX tốt hơn.',
        'Tách lớp service/repository giúp code dễ test và mở rộng.',
      ],
    ),
    FlutterTheoryTopic(
      title: 'Local DB',
      summary: 'Lưu dữ liệu cục bộ để dùng offline.',
      icon: Icons.storage,
      bullets: [
        'SharedPreferences dùng cho dữ liệu key-value nhỏ (token, setting).',
        'SQLite/sqflite phù hợp dữ liệu có cấu trúc dạng bảng.',
        'Nên đồng bộ local và server theo chiến lược cache rõ ràng.',
        'Đóng kết nối và chuẩn hóa thao tác DB để tăng hiệu năng.',
      ],
    ),
    FlutterTheoryTopic(
      title: 'UI/UX',
      summary: 'Thiết kế đẹp, dễ dùng và nhất quán trải nghiệm.',
      icon: Icons.palette,
      bullets: [
        'Dùng ThemeData để thống nhất màu sắc, font, button toàn app.',
        'Material 3 giúp giao diện hiện đại và đồng bộ với Android mới.',
        'Thiết kế responsive để hiển thị tốt trên nhiều kích thước màn hình.',
        'Ưu tiên khả năng đọc, tương phản màu và phản hồi thao tác rõ ràng.',
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
              'Flutter là framework UI đa nền tảng dùng Dart. '
                  'Bạn có thể build app Android/iOS/Web/Desktop từ 1 codebase.\n\n'
                  'Bên dưới là các chủ đề cốt lõi cùng nội dung lý thuyết '
                  'để bạn học nhanh và hệ thống.',
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlutterTheoryDetailPage(topic: topic),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
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
                    Text(
                      topic.summary,
                      style: summaryStyle,
                    ),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              topic.gradient.first.withOpacity(0.18),
              const Color(0xFFEFF6FF),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [topic.gradient.first, topic.gradient.last],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: topic.gradient.last.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(topic.icon, color: Colors.white, size: 30),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Lý thuyết cốt lõi',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    topic.summary,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      _QuickInfo(icon: Icons.schedule_rounded, label: '5 phút'),
                      SizedBox(width: 10),
                      _QuickInfo(icon: Icons.auto_awesome_rounded, label: 'Dễ hiểu'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFD8E4FF)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140F172A),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nội dung chính',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tóm tắt các ý quan trọng để bạn nắm nhanh phần ${topic.title}.',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    topic.bullets.length,
                    (index) => _TheoryPointCard(
                      index: index,
                      content: topic.bullets[index],
                      gradient: topic.gradient,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: topic.gradient.first.withOpacity(0.08),
                border: Border.all(color: topic.gradient.first.withOpacity(0.16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tips_and_updates_rounded,
                      color: topic.gradient.last, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mẹo học nhanh: đọc 1 lượt phần lý thuyết, sau đó tự code lại 1 ví dụ nhỏ theo chủ đề ${topic.title} để ghi nhớ lâu hơn.',
                      style: TextStyle(
                        color: const Color(0xFF1E293B),
                        fontSize: 14,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TheoryPointCard extends StatelessWidget {
  final int index;
  final String content;
  final List<Color> gradient;

  const _TheoryPointCard({
    required this.index,
    required this.content,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}',
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
          ),
        ],
      ),
    );
  }
}