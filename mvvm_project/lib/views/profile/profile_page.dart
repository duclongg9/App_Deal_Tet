import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginVM = context.watch<LoginViewModel>();
    final budgetVM = context.watch<TetBudgetViewModel>();
    final user = loginVM.session?.user;
    final userName = user?.userName ?? 'Khách';
    final spent = budgetVM.selectedYear != null ? budgetVM.spentByYear(budgetVM.selectedYear!.id) : 0;
    final totalBudget = budgetVM.selectedYear?.totalBudget ?? 0;

    return Scaffold(
      backgroundColor: TetColors.bgMain,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(context, userName),
                const SizedBox(height: TetSpacing.s6),
                _buildBudgetSummaryCard(spent, totalBudget),
                const SizedBox(height: TetSpacing.s6),
                _buildMenuSection(context, userName),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: TetColors.bgMain,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      title: const Text('Cá Nhân', style: TextStyle(color: TetColors.textPrimary, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(TetSpacing.s6),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: TetGradients.premiumGold),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: TetColors.primary50,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: TetColors.festiveRed),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: TetSpacing.s4),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Thành viên Vàng • Tết 2026',
              style: TextStyle(color: TetColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBudgetSummaryCard(int spent, int totalBudget) {
    final ratio = totalBudget > 0 ? (spent / totalBudget).clamp(0.0, 1.0) : 0.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TetSpacing.s5),
      padding: const EdgeInsets.all(TetSpacing.s5),
      decoration: BoxDecoration(
        gradient: TetGradients.tet,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: TetColors.festiveRed.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ngân Sách Tết 2026', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_fmt(spent)}đ', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              Text('/ ${_fmt(totalBudget)}đ', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(TetColors.accentGold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text('${(ratio * 100).toStringAsFixed(0)}% đã chi tiêu',
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String userName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TetSpacing.s5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.person_outline, 'Thông tin tài khoản',
              () => _showEditProfile(context, userName)),
          _buildDivider(),
          _buildMenuItem(Icons.notifications_none, 'Thông báo',
              () => consumer_notifications(context)),
          _buildDivider(),
          _buildMenuItem(Icons.help_outline, 'Hỗ trợ & Góp ý',
              () => _showHelp(context)),
        ],
      ),
    );
  }

  void consumer_notifications(BuildContext context) {
    // Navigate to notifications is handled from DealsHome
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xem thông báo tại trang Deals 🏮')),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: TetColors.primary50, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: TetColors.festiveRed, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: TetColors.textMuted),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, indent: 60, color: TetColors.border.withOpacity(0.5));

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s8),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: () => _handleLogout(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: TetColors.danger,
            side: const BorderSide(color: TetColors.danger, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
          ),
          child: const Text('Đăng Xuất', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, String currentName) {
    final nameCtrl = TextEditingController(text: currentName);
    final addressCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(TetSpacing.s6),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông tin cá nhân',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: TetSpacing.s6),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: const Icon(Icons.person_outline, color: TetColors.festiveRed),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên không được để trống' : null,
                ),
                const SizedBox(height: TetSpacing.s4),
                TextFormField(
                  controller: addressCtrl,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ (tùy chọn)',
                    prefixIcon: const Icon(Icons.home_outlined, color: TetColors.festiveRed),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
                  ),
                ),
                const SizedBox(height: TetSpacing.s6),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✓ Đã cập nhật thông tin!'), backgroundColor: TetColors.success),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TetColors.festiveRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
                    ),
                    child: const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hỗ trợ & Góp ý'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 Email: support@tetdeal.app'),
            SizedBox(height: 8),
            Text('📞 Hotline: 1800-TET-DEAL'),
            SizedBox(height: 8),
            Text('💬 Zalo OA: @AppDealTet2026'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng', style: TextStyle(color: TetColors.festiveRed)),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất', style: TextStyle(color: TetColors.danger)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<LoginViewModel>().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }
}

String _fmt(int amount) =>
    amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
