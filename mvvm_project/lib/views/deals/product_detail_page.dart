import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:mvvm_project/viewmodels/saved/saved_deals_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final String dealId;
  final String name;
  final int price;
  final IconData icon;
  final String storeName;
  final String imageUrl;

  const ProductDetailPage({
    super.key,
    required this.dealId,
    required this.name,
    required this.price,
    required this.icon,
    this.storeName = 'Không rõ',
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(context),
                _buildProductDetails(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: TetColors.textPrimary, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(name, style: const TextStyle(color: TetColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 16),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        Consumer<SavedDealsViewModel>(builder: (ctx, vm, _) {
          final isSaved = vm.isSaved(dealId);
          return IconButton(
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? TetColors.festiveRed : TetColors.textMuted),
            onPressed: () {
              vm.toggleSave(SavedDeal(id: dealId, name: name, price: price, storeName: storeName, icon: icon));
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(isSaved ? 'Đã xóa khỏi danh sách lưu' : '✓ Đã lưu deal!'),
                duration: const Duration(seconds: 1),
                backgroundColor: isSaved ? TetColors.textMuted : TetColors.success,
              ));
            },
          );
        }),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(color: TetColors.primary50),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(child: Icon(icon, size: 140, color: TetColors.festiveRed)),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator(color: TetColors.festiveRed));
              },
            )
          : Center(child: Icon(icon, size: 140, color: TetColors.festiveRed)),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TetSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: TetColors.primary50, borderRadius: BorderRadius.circular(TetRadius.sm)),
                child: const Text('Bestseller',
                    style: TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              const Spacer(),
              const Icon(Icons.star, color: TetColors.accentGold, size: 18),
              const SizedBox(width: 4),
              const Text('4.8 (120 đánh giá)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: TetSpacing.s4),
          Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: TetColors.textPrimary)),
          const SizedBox(height: TetSpacing.s2),
          Text('${_fmt(price)}đ',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: TetColors.festiveRed)),
          const SizedBox(height: TetSpacing.s6),
          _buildInfoRow(Icons.storefront, 'Cửa hàng', storeName),
          const SizedBox(height: TetSpacing.s3),
          _buildInfoRow(Icons.local_shipping_outlined, 'Vận chuyển', 'Giao ngay trong 2h'),
          const SizedBox(height: TetSpacing.s6),
          const Text('Mô tả sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: TetSpacing.s2),
          const Text(
            'Sản phẩm chất lượng cao, bao bì đẹp mắt mang đậm sắc Xuân, cực kỳ phù hợp làm quà biếu tặng hoặc chưng ban thờ dịp Tết Nguyên Đán 2026. Cam kết hàng chính hãng, hạn sử dụng mới nhất.',
            style: TextStyle(color: TetColors.textSecondary, height: 1.6, fontSize: 15),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData ic, String label, String value) {
    return Row(
      children: [
        Icon(ic, size: 18, color: TetColors.textMuted),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: TetColors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, color: TetColors.textPrimary),
              textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s6, vertical: TetSpacing.s4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Consumer<SavedDealsViewModel>(builder: (ctx, vm, _) {
              final isSaved = vm.isSaved(dealId);
              return Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: isSaved ? TetColors.primary50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(TetRadius.lg),
                ),
                child: IconButton(
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? TetColors.festiveRed : TetColors.textMuted),
                  onPressed: () => vm.toggleSave(SavedDeal(id: dealId, name: name, price: price, storeName: storeName, icon: icon)),
                ),
              );
            }),
            const SizedBox(width: TetSpacing.s4),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showBoughtDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TetColors.festiveRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
                    elevation: 0,
                  ),
                  child: const Text('✓ Đã mua sản phẩm này?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBoughtDialog(BuildContext context) {
    final budgetVM = context.read<TetBudgetViewModel>();
    final notifVM = context.read<NotificationsViewModel>();
    final year = budgetVM.selectedYear;

    if (year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng tạo năm ngân sách trước!')));
      return;
    }

    final categories = budgetVM.categoriesByYear(year.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(TetSpacing.s6),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cập Nhật Ngân Sách 🧧',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('Phân bổ "$name" vào hạng mục:',
                  style: const TextStyle(color: TetColors.textSecondary)),
              const SizedBox(height: TetSpacing.s6),
              if (categories.isEmpty)
                const Text('Chưa có hạng mục nào.\nVào trang Ngân sách để tạo hạng mục.',
                    style: TextStyle(color: TetColors.textSecondary))
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: categories.map((cat) {
                    return InkWell(
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        await budgetVM.addProduct(
                          categoryId: cat.id,
                          name: name,
                          price: price,
                          date: DateTime.now(),
                          imagePath: '',
                          receiptImagePath: '',
                          description: 'Từ cửa hàng: $storeName',
                        );
                        // Add notification
                        notifVM.addNotification(
                          title: '✅ Đã thêm vào ngân sách',
                          body: '"$name" (${_fmt(price)}đ) đã được thêm vào mục ${cat.name}.',
                          type: NotificationType.budget,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('🌸 Đã thêm vào mục ${cat.name}!'),
                            backgroundColor: TetColors.success,
                          ));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: TetColors.primary50,
                          borderRadius: BorderRadius.circular(TetRadius.md),
                          border: Border.all(color: TetColors.festiveRed.withOpacity(0.15)),
                        ),
                        child: Text(cat.name,
                            style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  String _fmt(int amount) =>
      amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
