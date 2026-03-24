import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/saved/saved_deals_viewmodel.dart';
import 'package:mvvm_project/views/deals/product_detail_page.dart';
import 'package:provider/provider.dart';

class SavedDealsPage extends StatelessWidget {
  const SavedDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetColors.bgMain,
      appBar: AppBar(
        backgroundColor: TetColors.bgMain,
        elevation: 0,
        title: const Text('Deal Đã Lưu 🧧',
            style: TextStyle(color: TetColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 22)),
        centerTitle: false,
        actions: [
          Consumer<SavedDealsViewModel>(
            builder: (ctx, vm, _) => vm.savedDeals.isNotEmpty
                ? TextButton(
                    onPressed: () => _showClearConfirm(ctx, vm),
                    child: const Text('Xóa tất cả', style: TextStyle(color: TetColors.danger)),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<SavedDealsViewModel>(
        builder: (context, vm, _) {
          if (vm.savedDeals.isEmpty) return _buildEmptyState();
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(TetSpacing.s5),
            itemCount: vm.savedDeals.length,
            separatorBuilder: (_, __) => const SizedBox(height: TetSpacing.s4),
            itemBuilder: (context, index) {
              final deal = vm.savedDeals[index];
              return Dismissible(
                key: Key(deal.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: TetColors.danger,
                    borderRadius: BorderRadius.circular(TetRadius.xl),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white),
                      Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                confirmDismiss: (_) async {
                  return await _showDeleteConfirm(context);
                },
                onDismissed: (_) {
                  vm.removeDeal(deal.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã xóa khỏi danh sách lưu'), duration: Duration(seconds: 1)),
                    );
                  }
                },
                child: _buildSavedItem(context, deal),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: TetColors.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'Chưa có deal nào được lưu\nHãy khám phá và lưu deal yêu thích nhé! 🎁',
            textAlign: TextAlign.center,
            style: TextStyle(color: TetColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedItem(BuildContext context, SavedDeal deal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TetRadius.xl),
          onTap: () {
            if (deal.icon is! IconData) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  dealId: deal.id,
                  name: deal.name,
                  price: deal.price,
                  icon: deal.icon as IconData,
                  storeName: deal.storeName,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(TetSpacing.s4),
            child: Row(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: TetColors.primary50,
                    borderRadius: BorderRadius.circular(TetRadius.lg),
                  ),
                  child: Icon(
                    deal.icon is IconData ? deal.icon as IconData : Icons.local_offer,
                    color: TetColors.festiveRed, size: 38),
                ),
                const SizedBox(width: TetSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deal.name,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: TetColors.textPrimary),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Tại ${deal.storeName}',
                          style: const TextStyle(fontSize: 12, color: TetColors.textSecondary)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_fmt(deal.price) + 'đ',
                              style: const TextStyle(fontWeight: FontWeight.w900, color: TetColors.festiveRed, fontSize: 18)),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: TetColors.textMuted),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xóa deal đã lưu?'),
            content: const Text('Deal này sẽ bị xóa khỏi danh sách lưu của bạn.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Xóa', style: TextStyle(color: TetColors.danger))),
            ],
          ),
        ) ??
        false;
  }

  void _showClearConfirm(BuildContext context, SavedDealsViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa tất cả?'),
        content: const Text('Danh sách lưu sẽ bị xóa hoàn toàn.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Xóa tất cả', style: TextStyle(color: TetColors.danger)),
          ),
        ],
      ),
    );
  }

  String _fmt(int amount) =>
      amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
