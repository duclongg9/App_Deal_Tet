import 'package:flutter/material.dart';

class ApiImagesPage extends StatefulWidget {
  const ApiImagesPage({super.key});

  @override
  State<ApiImagesPage> createState() => _ApiImagesPageState();
}

class _ApiImagesPageState extends State<ApiImagesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<int> _codes = const [
    100, 101, 200, 201, 202, 204,
    301, 302, 304,
    400, 401, 403, 404, 405, 408, 409, 418, 429,
    500, 501, 502, 503, 504,
  ];

  int _selected = 404;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String _imageUrl() {
    final idx = _tabController.index;

    if (idx == 0) {
      return 'https://http.cat/$_selected.jpg';
    }

    return 'https://http.dog/$_selected.jpg';
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F5);
    const headerBlue = Color(0xFF007AFF);
    const primary = Color(0xFF212121);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Xem ảnh qua API'),
        backgroundColor: headerBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          onTap: (_) => setState(() {}), // refresh url
          tabs: const [
            Tab(text: 'Cat'),
            Tab(text: 'Dog'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Dropdown chọn code
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primary.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selected,
                  isExpanded: true,
                  items: _codes
                      .map(
                        (c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        'HTTP $c',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selected = value!),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Image viewer
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: primary.withOpacity(0.18)),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _imageUrl(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 3.0,
                        child: Image.network(
                          _imageUrl(),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, widget, progress) {
                            if (progress == null) return widget;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Lỗi tải ảnh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: primary.withOpacity(0.85),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}