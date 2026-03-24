import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/deals/deals_home_page.dart';
import 'package:mvvm_project/views/deals/product_detail_page.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TetBudgetViewModel>().ensureSeedData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TetBudgetViewModel>();
    final selectedYear = vm.selectedYear;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: TetColors.bgMain,
      appBar: AppBar(
        backgroundColor: TetColors.bgMain,
        elevation: 0,
        title: const Text('Ngân Sách Tết',
            style: TextStyle(color: TetColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 22)),
        centerTitle: false,
        actions: [
          // Year selector popup - shows current year and next year
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: TetColors.primary50,
                borderRadius: BorderRadius.circular(TetRadius.md),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, color: TetColors.festiveRed, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    selectedYear != null ? 'Tết ${selectedYear.year}' : 'Chọn năm',
                    style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const Icon(Icons.arrow_drop_down, color: TetColors.festiveRed, size: 18),
                ],
              ),
            ),
            onSelected: (id) => vm.selectYear(id),
            itemBuilder: (_) => vm.years.map((y) {
              final isCurrentYear = y.year == now.year;
              final isNextYear = y.year == now.year + 1;
              final isValid = isCurrentYear || isNextYear;
              return PopupMenuItem(
                value: y.id,
                enabled: isValid,
                child: Opacity(
                  opacity: isValid ? 1.0 : 0.4,
                  child: Row(
                    children: [
                      Icon(
                        isCurrentYear
                            ? Icons.today
                            : isNextYear
                                ? Icons.event
                                : Icons.event_busy,
                        size: 16,
                        color: isCurrentYear ? TetColors.festiveRed : TetColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tết ${y.year}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCurrentYear ? TetColors.festiveRed : TetColors.textPrimary,
                            ),
                          ),
                          if (isCurrentYear)
                            const Text('Năm hiện tại', style: TextStyle(fontSize: 10, color: TetColors.textMuted)),
                          if (isNextYear)
                            const Text('Năm tới', style: TextStyle(fontSize: 10, color: TetColors.textMuted)),
                          if (!isValid)
                            const Text('Không khả dụng', style: TextStyle(fontSize: 10, color: TetColors.textMuted)),
                        ],
                      ),
                      if (vm.selectedYear?.id == y.id) ...[
                        const Spacer(),
                        const Icon(Icons.check, size: 16, color: TetColors.festiveRed),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator(color: TetColors.festiveRed))
          : selectedYear == null
              ? _buildEmptyState(context, vm)
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(TetSpacing.s5),
                  children: [
                    _buildBudgetCard(vm, selectedYear),
                    const SizedBox(height: TetSpacing.s8),
                    _buildSectionHeader('Phân Bổ Chi Tiêu', () => _showCategoryDialog(context, selectedYear, vm)),
                    const SizedBox(height: TetSpacing.s4),
                    _buildChartSection(vm, selectedYear),
                    const SizedBox(height: TetSpacing.s4),
                    _buildCategoryList(vm, selectedYear),
                    const SizedBox(height: TetSpacing.s8),
                    _buildSectionHeader('Lịch Sử Mua Sắm', null),
                    const SizedBox(height: TetSpacing.s4),
                    _buildProductHistory(vm, selectedYear),
                    const SizedBox(height: 100),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TetBudgetViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: TetColors.primary50, shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_wallet_outlined, size: 64, color: TetColors.festiveRed),
          ),
          const SizedBox(height: 24),
          const Text('Chưa có ngân sách nào', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Hãy tạo ngân sách của bạn để quản lý\nchi tiêu mùa Tết rủng rỉnh hơn nhé!',
              textAlign: TextAlign.center, style: TextStyle(color: TetColors.textSecondary, height: 1.5)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showCreateFirstYearDialog(context, vm),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Bắt đầu Tạo Ngân Sách', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: TetColors.festiveRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.full)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateFirstYearDialog(BuildContext context, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final budgetCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheet(
        title: 'Khởi tạo Ngân Sách Tết ${DateTime.now().year}',
        form: Form(
          key: formKey,
          child: _buildFormField(budgetCtrl, 'Tổng Ngân Sách Khởi Điểm (đ)', Icons.attach_money, type: TextInputType.number,
            validator: (v) {
              final b = int.tryParse(v?.replaceAll('.', '') ?? '');
              if (b == null || b <= 0) return 'Ngân sách phải lớn hơn 0';
              return null;
            }),
        ),
        onSave: () async {
          if (!formKey.currentState!.validate()) return;
          final budget = int.parse(budgetCtrl.text.replaceAll('.', ''));
          await vm.createYear(year: DateTime.now().year, totalBudget: budget);
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        if (onAdd != null)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: TetColors.festiveRed),
            onPressed: onAdd,
          ),
      ],
    );
  }

  Widget _buildBudgetCard(TetBudgetViewModel vm, TetYear year) {
    final spent = vm.spentByYear(year.id);
    final ratio = year.totalBudget == 0 ? 0.0 : spent / year.totalBudget;
    final isOverBudget = spent > year.totalBudget;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TetSpacing.s6),
      decoration: BoxDecoration(
        gradient: TetGradients.tet,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: TetColors.festiveRed.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tết ${year.year}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  if (isOverBudget)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(8)),
                      child: const Text('⚠ Vượt ngân sách!',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(width: 8),
                  // Edit budget button
                  GestureDetector(
                    onTap: () => _showEditYearDialog(context, year, vm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(TetRadius.md)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('Sửa budget', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TetSpacing.s4),
          const Text('Tổng Đã Chi', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: TetSpacing.s1),
          Text('${_fmt(spent)}đ', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: TetSpacing.s6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(isOverBudget ? Colors.red.shade300 : TetColors.accentGold),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: TetSpacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget: ${_fmt(year.totalBudget)}đ', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('${(ratio * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(TetBudgetViewModel vm, TetYear year) {
    final categories = vm.categoriesByYear(year.id);
    final data = categories.map((c) => (c, vm.spentByCategory(c.id))).where((e) => e.$2 > 0).toList();

    if (data.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(TetRadius.xl), border: Border.all(color: TetColors.border),
        ),
        child: const Center(child: Text('Chưa có chi tiêu nào', style: TextStyle(color: TetColors.textMuted))),
      );
    }

    final colors = [TetColors.deepCrimson, TetColors.accentGold, TetColors.festiveRed, const Color(0xFF00897B), Colors.blue.shade700];

    return Container(
      padding: const EdgeInsets.all(TetSpacing.s6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: CustomPaint(
              painter: _CircularPainter(values: data.map((e) => e.$2.toDouble()).toList()),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${data.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    const Text('Hạng mục', style: TextStyle(color: TetColors.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: TetSpacing.s6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.asMap().entries.map((entry) {
                final cat = entry.value.$1;
                final amount = entry.value.$2;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[entry.key % colors.length], shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(cat.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      Text('${_fmt(amount)}đ', style: const TextStyle(fontSize: 11, color: TetColors.textSecondary)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(TetBudgetViewModel vm, TetYear year) {
    final categories = vm.categoriesByYear(year.id);
    if (categories.isEmpty) {
      return const Center(child: Text('Chưa có hạng mục nào. Nhấn + để thêm.', style: TextStyle(color: TetColors.textMuted)));
    }

    return Column(
      children: categories.map((cat) {
        final spent = vm.spentByCategory(cat.id);
        final ratio = cat.budget > 0 ? (spent / cat.budget).clamp(0.0, 1.0) : 0.0;
        final isOver = spent > cat.budget;

        return Container(
          margin: const EdgeInsets.only(bottom: TetSpacing.s3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TetRadius.lg),
            border: Border.all(color: isOver ? TetColors.danger.withOpacity(0.3) : TetColors.border),
          ),
          child: ListTile(
            onTap: () => _showProductsByCategory(context, vm, cat),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isOver ? TetColors.danger.withOpacity(0.1) : TetColors.primary50,
                borderRadius: BorderRadius.circular(TetRadius.md),
              ),
              child: Icon(Icons.category_outlined, color: isOver ? TetColors.danger : TetColors.festiveRed, size: 22),
            ),
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(isOver ? TetColors.danger : TetColors.festiveRed),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${_fmt(spent)}đ / ${_fmt(cat.budget)}đ',
                    style: TextStyle(fontSize: 11, color: isOver ? TetColors.danger : TetColors.textSecondary)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (action) async {
                if (action == 'edit') {
                  _showEditCategoryDialog(context, cat, vm);
                } else if (action == 'delete') {
                  _confirmDeleteCategory(context, cat, vm);
                } else if (action == 'add') {
                  _showAddProductDialog(context, cat, vm);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'add', child: Row(children: [Icon(Icons.add, color: TetColors.festiveRed, size: 16), SizedBox(width: 8), Text('Thêm sản phẩm', style: TextStyle(color: TetColors.festiveRed))])),
                const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Sửa hạng mục')])),
                const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: TetColors.danger, size: 16), SizedBox(width: 8), Text('Xóa', style: TextStyle(color: TetColors.danger))])),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductHistory(TetBudgetViewModel vm, TetYear year) {
    final items = vm.recentProductsByYear(year.id);
    if (items.isEmpty) {
      return const Center(child: Text('Chưa có giao dịch nào.', style: TextStyle(color: TetColors.textMuted)));
    }

    return Column(
      children: items.map((product) {
        final category = vm.categoryById(product.categoryId);
        return Dismissible(
          key: Key(product.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(color: TetColors.danger, borderRadius: BorderRadius.circular(TetRadius.lg)),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          confirmDismiss: (_) async => await _confirmDeleteProduct(context),
          onDismissed: (_) async {
            await vm.deleteProduct(product.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa sản phẩm')));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: TetSpacing.s3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TetRadius.lg),
              border: Border.all(color: TetColors.border),
            ),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(TetRadius.lg)),
                  child: SizedBox(
                    width: 72, height: 72,
                    child: _buildProductImage(product.imagePath),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      if (product.imagePath.isNotEmpty && product.imagePath.startsWith('http')) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            dealId: product.id,
                            name: product.name,
                            price: product.price,
                            icon: Icons.receipt_long,
                            storeName: 'Ngân Sách Tết',
                            imageUrl: product.imagePath,
                          ),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Sản phẩm này không có chi tiết.'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(
                      '${category?.name ?? 'N/A'} • ${_dateStr(product.date)}',
                      style: const TextStyle(fontSize: 11, color: TetColors.textSecondary),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${_fmt(product.price)}đ',
                            style: const TextStyle(fontWeight: FontWeight.w900, color: TetColors.deepCrimson, fontSize: 14)),
                        GestureDetector(
                          onTap: () => _showEditProductDialog(context, product, vm),
                          child: const Text('Sửa', style: TextStyle(color: TetColors.festiveRed, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── DIALOGS ──────────────────────────────────────────────────────

  /// Sửa ngân sách năm - gọi vm.updateYear() thực sự
  Future<void> _showEditYearDialog(BuildContext context, TetYear year, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final budgetCtrl = TextEditingController(text: '${year.totalBudget}');
    await showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheet(
        title: 'Sửa Ngân Sách Tết ${year.year} 💰',
        form: Form(
          key: formKey,
          child: _buildFormField(budgetCtrl, 'Ngân sách mới (đ)', Icons.attach_money, type: TextInputType.number,
            validator: (v) {
              final b = int.tryParse(v?.replaceAll('.', '') ?? '');
              if (b == null || b <= 0) return 'Ngân sách phải lớn hơn 0';
              return null;
            }),
        ),
        onSave: () async {
          if (!formKey.currentState!.validate()) return;
          final budget = int.parse(budgetCtrl.text.replaceAll('.', ''));
          await vm.updateYear(yearId: year.id, totalBudget: budget);
          if (ctx.mounted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text('✅ Đã cập nhật ngân sách Tết ${year.year}!'), backgroundColor: TetColors.success),
            );
          }
        },
      ),
    );
  }

  Future<void> _showCategoryDialog(BuildContext context, TetYear year, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheet(
        title: 'Thêm Hạng Mục Chi Tiêu 🧧',
        form: Form(
          key: formKey,
          child: Column(
            children: [
              _buildFormField(nameCtrl, 'Tên hạng mục', Icons.label_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên không được để trống' : null),
              const SizedBox(height: TetSpacing.s4),
              _buildFormField(budgetCtrl, 'Ngân sách (đ)', Icons.attach_money, type: TextInputType.number,
                validator: (v) {
                  final b = int.tryParse(v?.replaceAll('.', '') ?? '');
                  if (b == null || b <= 0) return 'Ngân sách phải lớn hơn 0';
                  return null;
                }),
            ],
          ),
        ),
        onSave: () async {
          if (!formKey.currentState!.validate()) return;
          final budget = int.parse(budgetCtrl.text.replaceAll('.', ''));
          await vm.createCategory(yearId: year.id, name: nameCtrl.text.trim(), budget: budget);
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _showEditCategoryDialog(BuildContext context, TetCategory cat, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: cat.name);
    final budgetCtrl = TextEditingController(text: '${cat.budget}');
    await showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheet(
        title: 'Sửa Hạng Mục',
        form: Form(
          key: formKey,
          child: Column(
            children: [
              _buildFormField(nameCtrl, 'Tên hạng mục', Icons.label_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên không được để trống' : null),
              const SizedBox(height: TetSpacing.s4),
              _buildFormField(budgetCtrl, 'Ngân sách (đ)', Icons.attach_money, type: TextInputType.number,
                validator: (v) {
                  final b = int.tryParse(v?.replaceAll('.', '') ?? '');
                  if (b == null || b <= 0) return 'Ngân sách phải lớn hơn 0';
                  return null;
                }),
            ],
          ),
        ),
        onSave: () async {
          if (!formKey.currentState!.validate()) return;
          final budget = int.parse(budgetCtrl.text.replaceAll('.', ''));
          await vm.updateCategory(categoryId: cat.id, name: nameCtrl.text.trim(), budget: budget);
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  /// Thêm sản phẩm thủ công vào hạng mục
  Widget _buildProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        color: TetColors.primary50,
        child: const Center(child: Icon(Icons.shopping_bag_outlined, color: TetColors.festiveRed, size: 28)),
      );
    }
    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: TetColors.primary50,
            child: const Center(child: Icon(Icons.image_not_supported_outlined, color: TetColors.textMuted, size: 28)),
          ));
    }
    return Image.file(File(imagePath), fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: TetColors.primary50,
          child: const Center(child: Icon(Icons.broken_image_outlined, color: TetColors.textMuted, size: 28)),
        ));
  }

  Future<void> _showAddProductDialog(BuildContext context, TetCategory cat, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedImagePath = '';
    String selectedReceiptPath = '';
    DateTime selectedDate = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(TetSpacing.s6),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thêm sản phẩm 🛍️', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('Hạng mục: ${cat.name}', style: const TextStyle(color: TetColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: TetSpacing.s4),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildFormField(nameCtrl, 'Tên sản phẩm', Icons.shopping_bag_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên không được để trống' : null),
                      const SizedBox(height: TetSpacing.s4),
                      _buildFormField(priceCtrl, 'Giá (đ)', Icons.attach_money, type: TextInputType.number,
                        validator: (v) {
                          final p = int.tryParse(v?.replaceAll('.', '') ?? '');
                          if (p == null || p <= 0) return 'Giá phải lớn hơn 0';
                          return null;
                        }),
                      const SizedBox(height: TetSpacing.s4),
                      _buildFormField(descCtrl, 'Ghi chú (tùy chọn)', Icons.notes_outlined),
                      const SizedBox(height: TetSpacing.s4),
                      // Date picker
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(primary: TetColors.festiveRed),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) setModalState(() => selectedDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(TetRadius.md),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: TetColors.festiveRed, size: 20),
                              const SizedBox(width: 12),
                              Text('Ngày mua: ${_dateStr(selectedDate)}',
                                  style: const TextStyle(fontSize: 15)),
                              const Spacer(),
                              const Icon(Icons.edit_calendar_outlined, color: TetColors.textMuted, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: TetSpacing.s4),
                      // Chọn ảnh từ catalog Deal
                      OutlinedButton.icon(
                        onPressed: () async {
                          final deal = await showModalBottomSheet<Map<String, dynamic>>(
                            context: ctx,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _DealPickerSheet(),
                          );
                          if (deal != null) {
                            setModalState(() {
                              selectedImagePath = deal['imageUrl'] as String;
                              nameCtrl.text = deal['name'] as String;
                              priceCtrl.text = '${deal['price']}';
                            });
                          }
                        },
                        icon: const Icon(Icons.local_offer_outlined, size: 16),
                        label: const Text('Chọn từ Catalog Deal 🛍️', style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TetColors.festiveRed,
                          side: const BorderSide(color: TetColors.festiveRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
                          minimumSize: const Size(double.infinity, 44),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                      if (selectedImagePath.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(TetRadius.md),
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: _buildProductImage(selectedImagePath),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: TetSpacing.s6),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final priceStr = priceCtrl.text.replaceAll(RegExp(r'\D'), '');
                      final price = int.parse(priceStr.isEmpty ? '0' : priceStr);
                      
                      final spent = vm.spentByCategory(cat.id);
                      final isExceeding = (spent + price) > cat.budget;

                      await vm.addProduct(
                        categoryId: cat.id,
                        name: nameCtrl.text.trim(),
                        price: price,
                        date: selectedDate,
                        imagePath: selectedImagePath,
                        receiptImagePath: selectedReceiptPath,
                        description: descCtrl.text.trim(),
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        if (isExceeding) {
                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: const Row(children: [
                                Icon(Icons.warning_amber_rounded, color: TetColors.danger),
                                SizedBox(width: 8),
                                Text('Cảnh báo ngân sách', style: TextStyle(color: TetColors.danger, fontSize: 18))
                              ]),
                              content: Text('Sản phẩm "${nameCtrl.text.trim()}" đã làm hạng mục "${cat.name}" vượt quá ngân sách!'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Đã hiểu')),
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('✅ Đã thêm "${nameCtrl.text.trim()}" vào ${cat.name}!'),
                            backgroundColor: TetColors.success,
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TetColors.festiveRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
                    ),
                    child: const Text('Thêm Sản Phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProductDialog(BuildContext context, TetProduct product, TetBudgetViewModel vm) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: product.name);
    final priceCtrl = TextEditingController(text: '${product.price}');
    await showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheet(
        title: 'Sửa Sản Phẩm',
        form: Form(
          key: formKey,
          child: Column(
            children: [
              _buildFormField(nameCtrl, 'Tên sản phẩm', Icons.shopping_bag_outlined,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên không được để trống' : null),
              const SizedBox(height: TetSpacing.s4),
              _buildFormField(priceCtrl, 'Giá (đ)', Icons.attach_money, type: TextInputType.number,
                validator: (v) {
                  final p = int.tryParse(v?.replaceAll('.', '') ?? '');
                  if (p == null || p <= 0) return 'Giá phải lớn hơn 0';
                  return null;
                }),
            ],
          ),
        ),
        onSave: () async {
          if (!formKey.currentState!.validate()) return;
          final price = int.parse(priceCtrl.text.replaceAll('.', ''));
          await vm.updateProduct(
            productId: product.id,
            name: nameCtrl.text.trim(),
            price: price,
            date: product.date,
            description: product.description,
          );
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showProductsByCategory(BuildContext context, TetBudgetViewModel vm, TetCategory cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final products = vm.productsByCategory(cat.id);
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(TetSpacing.s6, TetSpacing.s6, TetSpacing.s3, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📦 ${cat.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                            Text('${_fmt(vm.spentByCategory(cat.id))}đ / ${_fmt(cat.budget)}đ',
                                style: const TextStyle(color: TetColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      // Add product button
                      TextButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await _showAddProductDialog(context, cat, vm);
                        },
                        icon: const Icon(Icons.add, color: TetColors.festiveRed, size: 18),
                        label: const Text('Thêm', style: TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          backgroundColor: TetColors.primary50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                      ),
                      IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                const Divider(height: 24),
                // Product list
                Expanded(
                  child: products.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 48, color: TetColors.textMuted),
                              SizedBox(height: 8),
                              Text('Chưa có sản phẩm nào', style: TextStyle(color: TetColors.textSecondary)),
                              SizedBox(height: 4),
                              Text('Nhấn "Thêm" để thêm sản phẩm', style: TextStyle(color: TetColors.textMuted, fontSize: 12)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s5),
                          itemCount: products.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (ctx, i) {
                            final p = products[i];
                            return Container(
                              decoration: BoxDecoration(
                                color: TetColors.bgMain,
                                borderRadius: BorderRadius.circular(TetRadius.md),
                                border: Border.all(color: TetColors.border),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                leading: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(color: TetColors.primary50, borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.shopping_bag_outlined, color: TetColors.festiveRed, size: 18),
                                ),
                                title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                subtitle: Text(_dateStr(p.date), style: const TextStyle(fontSize: 11, color: TetColors.textMuted)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${_fmt(p.price)}đ',
                                        style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.w900, fontSize: 13)),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert, size: 16, color: TetColors.textMuted),
                                      onSelected: (action) async {
                                        if (action == 'edit') {
                                          Navigator.pop(ctx);
                                          await _showEditProductDialog(context, p, vm);
                                        } else if (action == 'delete') {
                                          final ok = await _confirmDeleteProduct(context);
                                          if (ok) {
                                            await vm.deleteProduct(p.id);
                                            setModalState(() {}); // refresh list
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa sản phẩm')));
                                            }
                                          }
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 14), SizedBox(width: 6), Text('Sửa')])),
                                        PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: TetColors.danger, size: 14), SizedBox(width: 6), Text('Xóa', style: TextStyle(color: TetColors.danger))])),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, TetCategory cat, TetBudgetViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa hạng mục?'),
        content: Text('Xóa "${cat.name}" sẽ xóa luôn toàn bộ sản phẩm của hạng mục này.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await vm.deleteCategory(cat.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa hạng mục ${cat.name}')));
              }
            },
            child: const Text('Xóa', style: TextStyle(color: TetColors.danger)),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDeleteProduct(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xóa sản phẩm?'),
            content: const Text('Sản phẩm này sẽ bị xóa khỏi lịch sử và ngân sách sẽ được cập nhật.'),
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

  Widget _buildSheet({required String title, required Widget form, required VoidCallback onSave}) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(TetSpacing.s6),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: TetSpacing.s6),
            form,
            const SizedBox(height: TetSpacing.s6),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TetColors.festiveRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
                ),
                child: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      validator: validator,
      inputFormatters: [
        if (type == TextInputType.number) ...[
          FilteringTextInputFormatter.digitsOnly,
          _CurrencyInputFormatter(),
        ]
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: TetColors.festiveRed),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.md)),
      ),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final numString = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (numString.isEmpty) return const TextEditingValue(text: '');
    final number = int.parse(numString);
    final formatted = number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

String _fmt(int amount) =>
    amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

String _dateStr(DateTime d) => '${d.day}/${d.month}/${d.year}';

class _DealPickerSheet extends StatefulWidget {
  @override
  State<_DealPickerSheet> createState() => _DealPickerSheetState();
}

class _DealPickerSheetState extends State<_DealPickerSheet> {
  String _search = '';

  List<Map<String, dynamic>> get _filtered => kAllDeals
      .where((d) => (d['name'] as String).toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(TetRadius.xl)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(TetSpacing.s5, TetSpacing.s5, TetSpacing.s5, TetSpacing.s3),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Chọn Deal Từ Catalog 🛍️',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TetSpacing.s5),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Tìm deal...',
                prefixIcon: const Icon(Icons.search, color: TetColors.festiveRed),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(TetRadius.lg)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: TetSpacing.s3),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final deal = _filtered[i];
                final discount = deal['discount'] as int;
                return ListTile(
                  onTap: () => Navigator.pop(context, deal),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(TetRadius.md),
                    child: Image.network(
                      deal['imageUrl'] as String, width: 52, height: 52, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 52, height: 52, color: TetColors.primary50,
                        child: Icon(deal['icon'] as IconData, color: TetColors.festiveRed, size: 24),
                      ),
                    ),
                  ),
                  title: Text(deal['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(deal['store'] as String, style: const TextStyle(fontSize: 11, color: TetColors.textSecondary)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${_fmt(deal['price'] as int)}đ',
                          style: const TextStyle(color: TetColors.festiveRed, fontWeight: FontWeight.w900, fontSize: 13)),
                      if (discount >= 50)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: TetColors.accentGold, borderRadius: BorderRadius.circular(4)),
                          child: Text('-$discount%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: TetColors.deepCrimson)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _CircularPainter extends CustomPainter {
  final List<double> values;
  _CircularPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (s, v) => s + v);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    double startAngle = -math.pi / 2;
    final colors = [TetColors.deepCrimson, TetColors.accentGold, TetColors.festiveRed, const Color(0xFF00897B), Colors.blue.shade700];
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 14..strokeCap = StrokeCap.round;

    if (total == 0) {
      paint.color = TetColors.border;
      canvas.drawCircle(center, radius - 8, paint);
      return;
    }

    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 8), startAngle + 0.05, sweep - 0.1, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
