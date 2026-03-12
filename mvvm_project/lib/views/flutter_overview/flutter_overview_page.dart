import 'package:flutter/material.dart';

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
              style: TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w600),
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
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              topic.summary,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          ...topic.bullets.map(
            (item) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Color(0xFF1E88E5)),
                title: Text(item, style: const TextStyle(fontSize: 16, height: 1.35)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
