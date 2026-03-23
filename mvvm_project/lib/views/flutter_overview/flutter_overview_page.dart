import 'package:flutter/material.dart';
import 'package:mvvm_project/data/implementations/repositories/flutter_overview_repository.dart';
import 'package:mvvm_project/viewmodels/flutter_overview/flutter_overview_viewmodel.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_overview_styles.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_theory_detail_page.dart';
import 'package:mvvm_project/views/flutter_overview/widgets/topic_card.dart';
import 'package:provider/provider.dart';

const summaryStyle = TextStyle(
  fontSize: 16,
  height: 1.45,
  fontWeight: FontWeight.w500,
  color: Color(0xFF3B4A63),
);

class FlutterTheoryTopic {
  final String title;
  final String summary;
  final IconData icon;
  final List<String> bullets;
  final List<Color> gradient;

  const FlutterTheoryTopic({
    required this.title,
    required this.summary,
    required this.icon,
    required this.bullets,
    required this.gradient,
  });
}

class FlutterOverviewPage extends StatelessWidget {
  const FlutterOverviewPage({super.key});

  static const List<FlutterTheoryTopic> _topics = [
    FlutterTheoryTopic(
      title: 'Widget',
      summary: 'Mọi thứ trong Flutter đều là Widget.',
      icon: Icons.widgets_rounded,
      gradient: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
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
      icon: Icons.space_dashboard_rounded,
      gradient: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
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
      icon: Icons.route_rounded,
      gradient: [Color(0xFF0891B2), Color(0xFF0D9488)],
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
      icon: Icons.model_training_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFFF97316)],
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
      icon: Icons.cloud_sync_rounded,
      gradient: [Color(0xFFDB2777), Color(0xFFBE185D)],
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
      icon: Icons.storage_rounded,
      gradient: [Color(0xFF9333EA), Color(0xFF6366F1)],
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
      icon: Icons.palette_rounded,
      gradient: [Color(0xFF06B6D4), Color(0xFF0284C7)],
      bullets: [
        'Dùng ThemeData để thống nhất màu sắc, font, button toàn app.',
        'Material 3 giúp giao diện hiện đại và đồng bộ với Android mới.',
        'Thiết kế responsive để hiển thị tốt trên nhiều kích thước màn hình.',
        'Ưu tiên khả năng đọc, tương phản màu và phản hồi thao tác rõ ràng.',
      ],
    ),
  ];

class _FlutterOverviewView extends StatelessWidget {
  const _FlutterOverviewView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlutterOverviewViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Flutter Overview'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF38BDF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            children: [
              const _HeroHeader(),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _InfoChip(icon: Icons.phone_android, label: 'Android'),
                  _InfoChip(icon: Icons.apple, label: 'iOS'),
                  _InfoChip(icon: Icons.desktop_windows, label: 'Desktop'),
                  _InfoChip(icon: Icons.public, label: 'Web'),
                ],
              ),
              const SizedBox(height: 18),
              ..._topics.map((topic) => _TopicCard(topic: topic)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lộ trình Flutter',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 30,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Flutter là framework UI đa nền tảng dùng Dart. Bạn có thể build app Android, iOS, Web và Desktop từ một codebase.\n\nBên dưới là phần lý thuyết cốt lõi được thiết kế lại dạng thẻ hiện đại để học nhanh và dễ nhớ.',
            style: TextStyle(
              color: Color(0xFFE7F0FF),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.16),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: topic.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: topic.gradient.last.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(topic.icon, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.summary,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE8EEFF),
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      );
    }

class FlutterTheoryDetailPage extends StatelessWidget {
  final FlutterTheoryTopic topic;

  const FlutterTheoryDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        foregroundColor: Colors.white,
        backgroundColor: topic.gradient.last,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              topic.gradient.first.withOpacity(0.12),
              const Color(0xFFF8FAFC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: topic.gradient),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(topic.icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      topic.summary,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...topic.bullets.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x110F172A),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: topic.gradient),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
