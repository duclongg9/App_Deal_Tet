import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  final String userName;

  const AdminHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // Sidebar (Visible on Tablet/Web)
          if (MediaQuery.of(context).size.width > 600) _buildSidebar(context),
          
          // Main Dashboard
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(TetSpacing.s6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsGrid(),
                        const SizedBox(height: TetSpacing.s8),
                        const Text('Biểu Đồ Tăng Trưởng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: TetSpacing.s4),
                        _buildMainChart(),
                        const SizedBox(height: TetSpacing.s8),
                        const Text('Yêu Cầu Gần Đây', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: TetSpacing.s4),
                        _buildRecentActivitiesList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 260,
      color: TetColors.deepCrimson,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text('TẾT ADMIN', style: TextStyle(color: TetColors.accentGold, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 40),
          _buildSidebarItem(Icons.dashboard, 'Tổng Quan', true),
          _buildSidebarItem(Icons.people, 'Người Dùng', false),
          _buildSidebarItem(Icons.inventory, 'Sản Phẩm', false),
          _buildSidebarItem(Icons.analytics, 'Báo Cáo', false),
          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Đăng Xuất', false, onTap: () => _handleLogout(context)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? TetColors.accentGold : Colors.white70),
      title: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      tileColor: isSelected ? Colors.white.withOpacity(0.1) : null,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      pinned: true,
      title: Text('Hệ Thống Quản Trị', style: TextStyle(color: TetColors.textPrimary, fontWeight: FontWeight.w900)),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none, color: TetColors.textPrimary), onPressed: () {}),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: TetColors.primary50,
          child: Text(userName[0], style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: TetSpacing.s4,
      mainAxisSpacing: TetSpacing.s4,
      children: [
        _buildStatCard('Tổng User', '1,240', Icons.people, TetColors.festiveRed),
        _buildStatCard('Doanh Thu', '450M', Icons.attach_money, TetColors.success),
        _buildStatCard('Sản Phẩm', '85', Icons.inventory, Colors.blue),
        _buildStatCard('Bình Luận', '12k', Icons.comment, TetColors.accentGold),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(TetSpacing.s4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Text(title, style: const TextStyle(color: TetColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(TetSpacing.s6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(TetRadius.xl)),
      child: CustomPaint(
        painter: _LineChartPainter(),
      ),
    );
  }

  Widget _buildRecentActivitiesList() {
    return Column(
      children: List.generate(3, (index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(TetRadius.md)),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text('User ${index + 1} vừa cập nhật ngân sách'),
          subtitle: const Text('10 phút trước'),
          trailing: const Icon(Icons.chevron_right),
        ),
      )),
    );
  }

  void _handleLogout(BuildContext context) async {
    await context.read<LoginViewModel>().logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
    }
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = TetColors.festiveRed..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.9, size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.1);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
