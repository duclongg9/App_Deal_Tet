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
    100,
    101,
    200,
    201,
    202,
    204,
    301,
    302,
    304,
    400,
    401,
    403,
    404,
    405,
    408,
    409,
    418,
    429,
    500,
    501,
    502,
    503,
    504,
  ];

  int _selected = 404;
  int _imageAttempt = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _resetImageAttempt();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> _imageCandidates() {
    final isCat = _tabController.index == 0;
    if (isCat) {
      return [
        'https://http.cat/$_selected.jpg',
        'https://http.cat/$_selected',
      ];
    }

    return [
      'https://http.dog/$_selected.jpg',
      'https://http.dog/$_selected',
    ];
  }

  String _activeImageUrl() {
    final candidates = _imageCandidates();
    if (_imageAttempt < candidates.length) {
      return candidates[_imageAttempt];
    }
    return candidates.last;
  }

  void _resetImageAttempt() {
    if (!mounted) return;
    setState(() => _imageAttempt = 0);
  }

  void _useNextImageCandidate() {
    final candidates = _imageCandidates();
    if (_imageAttempt >= candidates.length - 1) {
      return;
    }

    if (!mounted) return;
    setState(() => _imageAttempt += 1);
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F5);
    const headerBlue = Color(0xFF007AFF);
    const primary = Color(0xFF212121);
    final imageUrl = _activeImageUrl();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Xem ảnh qua API'),
        backgroundColor: headerBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          onTap: (_) => _resetImageAttempt(),
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
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selected = value;
                      _imageAttempt = 0;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                      imageUrl,
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
                          imageUrl,
                          key: ValueKey(imageUrl),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, widget, progress) {
                            if (progress == null) return widget;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _useNextImageCandidate();
                            });

                            final isLastTry =
                                _imageAttempt >= _imageCandidates().length - 1;
                            if (!isLastTry) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Center(
                              child: Text(
                                'Lỗi tải ảnh\nVui lòng thử mã HTTP khác.',
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
