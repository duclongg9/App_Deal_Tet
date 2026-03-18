import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:mvvm_project/viewmodels/saved/saved_deals_viewmodel.dart';
import 'package:mvvm_project/views/deals/product_detail_page.dart';
import 'package:mvvm_project/views/notifications/notifications_page.dart';
import 'package:provider/provider.dart';

// Immutable mock data for app deals catalog
final List<Map<String, dynamic>> kAllDeals = [
  {
    'id': '1',
    'name': 'Thùng Bia Heineken',
    'price': 450000,
    'oldPrice': 480000,
    'icon': Icons.local_drink,
    'store': 'Bách Hóa Xanh',
    'storeColor': const Color(0xFF00897B),
    'category': 'Đồ Uống',
    'imageUrl': 'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=400&q=80',
  },
  {
    'id': '2',
    'name': 'Hộp Mứt Tết Cao Cấp',
    'price': 250000,
    'oldPrice': 320000,
    'icon': Icons.cookie,
    'store': 'Co.opmart',
    'storeColor': const Color(0xFF1976D2),
    'category': 'Quà Biếu',
    'imageUrl': 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400&q=80',
  },
  {
    'id': '3',
    'name': 'Bánh Chưng Đặc Biệt',
    'price': 120000,
    'oldPrice': 150000,
    'icon': Icons.bakery_dining,
    'store': 'Siêu thị Vinmart',
    'storeColor': const Color(0xFF7B1FA2),
    'category': 'Đặc Sản',
    'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
  },
  {
    'id': '4',
    'name': 'Rượu Vang Chi-lê',
    'price': 850000,
    'oldPrice': 1100000,
    'icon': Icons.wine_bar,
    'store': 'Lotte Mart',
    'storeColor': const Color(0xFFC62828),
    'category': 'Đồ Uống',
    'imageUrl': 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=400&q=80',
  },
  {
    'id': '5',
    'name': 'Hộp Quà Trà Ô Long',
    'price': 180000,
    'oldPrice': 220000,
    'icon': Icons.local_cafe,
    'store': 'Phúc Long',
    'storeColor': const Color(0xFF388E3C),
    'category': 'Quà Biếu',
    'imageUrl': 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&q=80',
  },
  {
    'id': '6',
    'name': 'Gói Hạt Châu Mỹ',
    'price': 95000,
    'oldPrice': 120000,
    'icon': Icons.breakfast_dining,
    'store': 'Bách Hóa Xanh',
    'storeColor': const Color(0xFF00897B),
    'category': 'Đặc Sản',
    'imageUrl': 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&q=80',
  },
  {
    'id': '7',
    'name': 'Đèn Lồng Trang Trí',
    'price': 75000,
    'oldPrice': 95000,
    'icon': Icons.light,
    'store': 'Shopee Mall',
    'storeColor': const Color(0xFFE64A19),
    'category': 'Trang Trí',
    'imageUrl': 'https://images.unsplash.com/photo-1583425423888-e1af0c4a09e4?w=400&q=80',
  },
  {
    'id': '8',
    'name': 'Hoa Mai Vàng Giả',
    'price': 320000,
    'oldPrice': 450000,
    'icon': Icons.filter_vintage,
    'store': 'Lazada',
    'storeColor': const Color(0xFF6A1B9A),
    'category': 'Trang Trí',
    'imageUrl': 'https://images.unsplash.com/photo-1490750967868-88df5691cc40?w=400&q=80',
  },
];

class DealsHomePage extends StatefulWidget {
  final String userName;
  const DealsHomePage({super.key, required this.userName});

  @override
  State<DealsHomePage> createState() => _DealsHomePageState();
}

class _DealsHomePageState extends State<DealsHomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = ['Tất cả', 'Quà Biếu', 'Đặc Sản', 'Trang Trí', 'Đồ Uống'];

  List<Map<String, dynamic>> get _filteredDeals {
    var result = kAllDeals;

    // Lọc theo danh mục
    if (_selectedCategory != 'Tất cả') {
      result = result.where((d) => d['category'] == _selectedCategory).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((d) => (d['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final notifVM = context.watch<NotificationsViewModel>();

    return Scaffold(
      backgroundColor: TetColors.bgMain,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, notifVM),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TetSpacing.s3),
                  _buildSearchBar(),
                  const SizedBox(height: TetSpacing.s4),
                  _buildPremiumBanner(),
                  const SizedBox(height: TetSpacing.s5),
                  _buildCategoryFilter(),
                  const SizedBox(height: TetSpacing.s6),
                  _buildSectionHeader('Deal Tết Đang Hot 🔥'),
                  const SizedBox(height: TetSpacing.s4),
                  _buildHotDealsGrid(),
                  const SizedBox(height: TetSpacing.s10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, NotificationsViewModel notifVM) {
    return SliverAppBar(
      backgroundColor: TetColors.bgMain,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: TetSpacing.s5, bottom: TetSpacing.s4),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào Xuân, ${widget.userName}!',
                style: const TextStyle(color: TetColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w900)),
            const Text('Tết này sắm gì nhỉ? 🏮',
                style: TextStyle(color: TetColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: TetSpacing.s3, top: 8),
          child: Stack(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.notifications_outlined, color: TetColors.textPrimary, size: 20),
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
              ),
              if (notifVM.unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(color: TetColors.festiveRed, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${notifVM.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm deal Tết...',
          prefixIcon: const Icon(Icons.search, color: TetColors.festiveRed),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.lg), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: TetGradients.tet,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: TetColors.festiveRed.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20,
              child: Icon(Icons.filter_vintage, size: 150, color: Colors.white.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s6, vertical: TetSpacing.s5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: TetColors.accentGold, borderRadius: BorderRadius.circular(TetRadius.sm)),
                      child: const Text('SALE KHỦNG 50%',
                          style: TextStyle(color: TetColors.deepCrimson, fontWeight: FontWeight.w900, fontSize: 10)),
                    ),
                    const SizedBox(height: TetSpacing.s2),
                    const Text('Siêu Deal Tết\nAn Khang 2026',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.2)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 36), // Override global infinite width theme
                    backgroundColor: Colors.white,
                    foregroundColor: TetColors.festiveRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
                    elevation: 0,
                  ),
                  child: const Text('Xem Ngay', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? TetColors.festiveRed : Colors.white,
                borderRadius: BorderRadius.circular(TetRadius.full),
                border: Border.all(color: isSelected ? TetColors.festiveRed : TetColors.border),
                boxShadow: isSelected
                    ? [BoxShadow(color: TetColors.festiveRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
              ),
              child: Text(cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : TetColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: TetColors.textPrimary)),
        const Spacer(),
        if (_selectedCategory != 'Tất cả')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: TetColors.festiveRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TetRadius.sm),
            ),
            child: Text(_selectedCategory, style: const TextStyle(color: TetColors.festiveRed, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildHotDealsGrid() {
    final deals = _filteredDeals;
    if (deals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 60, color: TetColors.textMuted),
              SizedBox(height: 12),
              Text('Không tìm thấy deal nào', style: TextStyle(color: TetColors.textSecondary, fontSize: 16)),
            ],
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        crossAxisSpacing: TetSpacing.s4,
        mainAxisSpacing: TetSpacing.s4,
      ),
      itemBuilder: (context, index) {
        final deal = deals[index];
        return _buildDealCard(context, deal);
      },
    );
  }

  Widget _buildDealCard(BuildContext context, Map<String, dynamic> deal) {
    return Consumer<SavedDealsViewModel>(
      builder: (context, savedVM, _) {
        final isSaved = savedVM.isSaved(deal['id'] as String);
        final storeColor = deal['storeColor'] as Color;
        final storeName = deal['store'] as String;
        final storeInitials = storeName.split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              dealId: deal['id'] as String,
              name: deal['name'] as String,
              price: deal['price'] as int,
              icon: deal['icon'] as IconData,
              storeName: storeName,
              imageUrl: deal['imageUrl'] as String,
            ),
          )),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TetRadius.xl),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Product image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
                        child: Image.network(
                          deal['imageUrl'] as String,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: TetColors.primary50,
                            child: Center(child: Icon(deal['icon'] as IconData, size: 60, color: TetColors.festiveRed)),
                          ),
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: TetColors.primary50,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: TetColors.festiveRed)),
                            );
                          },
                        ),
                      ),
                      // Store logo badge (top-left)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: storeColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                          ),
                          child: Text(storeInitials,
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                        ),
                      ),
                      // Save/heart button (top-right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            savedVM.toggleSave(SavedDeal(
                              id: deal['id'] as String,
                              name: deal['name'] as String,
                              price: deal['price'] as int,
                              storeName: storeName,
                              icon: deal['icon'],
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(isSaved ? 'Đã xóa khỏi danh sách lưu' : '✓ Đã lưu deal!'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: isSaved ? TetColors.textMuted : TetColors.success,
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 5)]),
                            child: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                                color: isSaved ? TetColors.festiveRed : TetColors.textMuted, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TetSpacing.s3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deal['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: storeColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(storeName,
                                style: TextStyle(color: storeColor, fontSize: 10, fontWeight: FontWeight.w600),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: TetSpacing.s1),
                      Row(
                        children: [
                          Expanded(
                            child: Text('${_fmt(deal['price'] as int)}đ',
                                style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.w900, fontSize: 13)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(color: TetColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '-${(((deal['oldPrice'] as int) - (deal['price'] as int)) / (deal['oldPrice'] as int) * 100).round()}%',
                              style: const TextStyle(color: TetColors.success, fontWeight: FontWeight.bold, fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmt(int amount) =>
      amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
