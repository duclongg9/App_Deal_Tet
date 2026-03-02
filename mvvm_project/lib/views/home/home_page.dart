import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:mvvm_project/viewmodels/tet/tet_budget_viewmodel.dart';
import 'package:mvvm_project/views/login_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Tết Trong Tay • ${widget.userName}'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<LoginViewModel>().logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showYearDialog(context),
        elevation: 0,
        child: Ink(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            gradient: TetGradients.wallet,
            shape: BoxShape.circle,
            boxShadow: TetShadows.lg,
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: selectedYear == null
            ? const Center(child: Text('Chưa có dữ liệu năm, vui lòng tạo năm mới.'))
            : ListView(
                padding: const EdgeInsets.all(TetSpacing.s5),
                children: [
                  Container(
                    padding: const EdgeInsets.all(TetSpacing.s6),
                    decoration: BoxDecoration(
                      gradient: TetGradients.tet,
                      borderRadius: BorderRadius.circular(TetRadius.lg),
                    ),
                    child: Text(
                      'Chúc mừng năm mới! Theo dõi ngân sách Tết thông minh ✨',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: TetSpacing.s3),
                  _buildYearBudgetCard(context, vm, selectedYear),
                  const SizedBox(height: TetSpacing.s4),
                  _buildDonutCard(vm, selectedYear),
                  const SizedBox(height: TetSpacing.s4),
                  _buildRecentHistory(context, vm, selectedYear),
                ],
              ),
      ),
    );
  }

  Widget _buildYearBudgetCard(BuildContext context, TetBudgetViewModel vm, TetYear year) {
    final spent = vm.spentByYear(year.id);
    final ratio = year.totalBudget == 0 ? 0.0 : spent / year.totalBudget;
    final overSpent = spent > year.totalBudget;

    return Container(
      decoration: BoxDecoration(
        gradient: TetGradients.wallet,
        borderRadius: BorderRadius.circular(TetRadius.xl),
        boxShadow: TetShadows.md,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(TetRadius.xl),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => YearDetailPage(yearId: year.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(TetSpacing.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: year.id,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  labelText: 'Năm ngân sách',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                items: vm.years
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Text('Tết ${item.year}'),
                        ))
                    .toList(),
                onChanged: (value) => vm.selectYear(value),
              ),
              const SizedBox(height: 12),
              Text(
                '${formatMoney(spent)} / ${formatMoney(year.totalBudget)} VND',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: ratio.isFinite ? ratio.clamp(0, 1) : 0,
                minHeight: 8,
                borderRadius: BorderRadius.circular(TetRadius.full),
                backgroundColor: Colors.white24,
                color: overSpent ? TetColors.danger : TetColors.accentGold,
              ),
              const SizedBox(height: 8),
              Text(
                'Đã dùng ${(ratio * 100).toStringAsFixed(0)}%${overSpent ? ' • Vượt ngân sách!' : ''}',
                style: TextStyle(color: overSpent ? Colors.red.shade100 : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonutCard(TetBudgetViewModel vm, TetYear year) {
    final categories = vm.categoriesByYear(year.id);
    final data = categories
        .map((category) => (category, vm.spentByCategory(category.id)))
        .where((item) => item.$2 > 0)
        .toList();

    const colors = [Colors.blue, Colors.amber, Colors.deepOrange, Colors.green, Colors.purple];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TetSpacing.s5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Biểu đồ phân bổ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (data.isEmpty)
              const Text('Chưa có dữ liệu chi tiêu để hiển thị biểu đồ.')
            else
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomPaint(
                        painter: _DonutPainter(
                          values: data.map((e) => e.$2.toDouble()).toList(),
                          colors: List.generate(data.length, (index) => colors[index % colors.length]),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (_, index) {
                            final category = data[index].$1;
                            final spent = data[index].$2;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 6, backgroundColor: colors[index % colors.length]),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('${category.name} – ${formatMoney(spent)}')),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentHistory(BuildContext context, TetBudgetViewModel vm, TetYear year) {
    final items = vm.recentProductsByYear(year.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TetSpacing.s5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lịch sử gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('Chưa có sản phẩm nào.')
            else
              SizedBox(
                height: 260,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final product = items[index];
                      final category = vm.categoryById(product.categoryId);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)),
                        title: Text(product.name),
                        subtitle: Text('${category?.name ?? 'N/A'} • ${formatDate(product.date)}'),
                        trailing: Text('${formatMoney(product.price)}đ'),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => YearDetailPage(yearId: year.id)),
                );
              },
              child: const Text('Xem chi tiết năm'),
            ),
          ],
        ),
      ),
    );
  }
}

class YearDetailPage extends StatelessWidget {
  final String yearId;

  const YearDetailPage({super.key, required this.yearId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TetBudgetViewModel>();
    final year = vm.years.where((item) => item.id == yearId).first;
    final categories = vm.categoriesByYear(yearId);
    final spent = vm.spentByYear(yearId);
    final ratio = year.totalBudget == 0 ? 0.0 : spent / year.totalBudget;

    return Scaffold(
      appBar: AppBar(title: Text('Tết ${year.year}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${formatMoney(spent)} / ${formatMoney(year.totalBudget)} VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: ratio.clamp(0, 1), minHeight: 10),
          const SizedBox(height: 8),
          Text('Đã dùng ${(ratio * 100).toStringAsFixed(0)}%'),
          const SizedBox(height: 16),
          const Text('Danh sách hạng mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (categories.isEmpty) const Text('Chưa có hạng mục.'),
          ...categories.map((category) {
            final categorySpent = vm.spentByCategory(category.id);
            final categoryRatio = category.budget == 0 ? 0.0 : categorySpent / category.budget;
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoryProductPage(categoryId: category.id)),
                  );
                },
                title: Text(category.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${formatMoney(categorySpent)} / ${formatMoney(category.budget)}'),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: categoryRatio.clamp(0, 1)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showEditCategoryDialog(context, category),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () => _confirmDeleteCategory(context, category),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _showCategoryDialog(context, year),
            icon: const Icon(Icons.add),
            label: const Text('Tạo hạng mục mới'),
          ),
        ],
      ),
    );
  }
}

class CategoryProductPage extends StatelessWidget {
  final String categoryId;

  const CategoryProductPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TetBudgetViewModel>();
    final category = vm.categoryById(categoryId)!;
    final products = vm.productsByCategory(categoryId);
    final spent = vm.spentByCategory(categoryId);
    final ratio = category.budget == 0 ? 0.0 : spent / category.budget;

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context, category),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${formatMoney(spent)} / ${formatMoney(category.budget)} VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: ratio.clamp(0, 1), minHeight: 10),
          const SizedBox(height: 8),
          Text('Đã dùng ${(ratio * 100).toStringAsFixed(0)}%'),
          const SizedBox(height: 12),
          if (products.isEmpty) const Center(child: Text('Chưa có sản phẩm, nhấn + để thêm mới.')),
          ...products.map(
            (product) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.shopping_bag_outlined)),
                title: Text(product.name),
                subtitle: Text('${formatDate(product.date)}\n${product.description.isEmpty ? 'Chưa có mô tả' : product.description}'),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditProductDialog(context, product);
                    } else {
                      _confirmDeleteProduct(context, product);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Sửa')),
                    PopupMenuItem(value: 'delete', child: Text('Xóa')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showYearDialog(BuildContext context) async {
  final yearCtrl = TextEditingController(text: DateTime.now().year.toString());
  final budgetCtrl = TextEditingController(text: '6000000');

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tạo năm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: yearCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Năm')),
            const SizedBox(height: 12),
            TextField(controller: budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Tổng ngân sách năm')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final year = int.tryParse(yearCtrl.text.trim());
                final budget = int.tryParse(_digitsOnly(budgetCtrl.text));
                if (year == null || budget == null || budget <= 0) return;
                await context.read<TetBudgetViewModel>().createYear(year: year, totalBudget: budget);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _showCategoryDialog(BuildContext context, TetYear year) async {
  final nameCtrl = TextEditingController();
  final budgetCtrl = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tạo hạng mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên hạng mục')),
            const SizedBox(height: 12),
            TextField(controller: budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ngân sách hạng mục')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final budget = int.tryParse(_digitsOnly(budgetCtrl.text));
                if (name.isEmpty || budget == null || budget <= 0) return;
                await context.read<TetBudgetViewModel>().createCategory(
                      yearId: year.id,
                      name: name,
                      budget: budget,
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _showEditCategoryDialog(BuildContext context, TetCategory category) async {
  final nameCtrl = TextEditingController(text: category.name);
  final budgetCtrl = TextEditingController(text: category.budget.toString());

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sửa hạng mục'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên hạng mục')),
          const SizedBox(height: 12),
          TextField(controller: budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ngân sách')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () async {
            final budget = int.tryParse(_digitsOnly(budgetCtrl.text));
            if (nameCtrl.text.trim().isEmpty || budget == null || budget <= 0) return;
            await context.read<TetBudgetViewModel>().updateCategory(
                  categoryId: category.id,
                  name: nameCtrl.text.trim(),
                  budget: budget,
                );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    ),
  );
}

Future<void> _confirmDeleteCategory(BuildContext context, TetCategory category) async {
  final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xóa hạng mục'),
          content: Text('Bạn có chắc muốn xóa "${category.name}" và toàn bộ sản phẩm liên quan?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
          ],
        ),
      ) ??
      false;

  if (!ok || !context.mounted) return;
  await context.read<TetBudgetViewModel>().deleteCategory(category.id);
}

Future<void> _showProductDialog(BuildContext context, TetCategory category) async {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final vm = context.watch<TetBudgetViewModel>();
          final currentSpent = vm.spentByCategory(category.id);
          final price = int.tryParse(_digitsOnly(priceCtrl.text)) ?? 0;
          final over = currentSpent + price - category.budget;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Thêm sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Hạng mục: ${category.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.image_outlined), label: const Text('Chọn ảnh sản phẩm')),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.receipt_long_outlined), label: const Text('Chụp ảnh hóa đơn')),
                const SizedBox(height: 8),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(labelText: 'Giá mua'),
                ),
                if (over > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '⚠️ Vượt chỉ tiêu hạng mục! (Vượt ${formatMoney(over)}đ)',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ngày mua'),
                  subtitle: Text(formatDate(selectedDate)),
                  trailing: IconButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                TextField(
                  controller: descriptionCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final priceValue = int.tryParse(_digitsOnly(priceCtrl.text));
                    if (nameCtrl.text.trim().isEmpty || priceValue == null || priceValue <= 0) return;
                    await context.read<TetBudgetViewModel>().addProduct(
                          categoryId: category.id,
                          name: nameCtrl.text.trim(),
                          price: priceValue,
                          date: selectedDate,
                          imagePath: '',
                          receiptImagePath: '',
                          description: descriptionCtrl.text.trim(),
                        );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showEditProductDialog(BuildContext context, TetProduct product) async {
  final nameCtrl = TextEditingController(text: product.name);
  final priceCtrl = TextEditingController(text: product.price.toString());
  final descriptionCtrl = TextEditingController(text: product.description);
  DateTime selectedDate = product.date;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sửa sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
            const SizedBox(height: 12),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giá mua')),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ngày mua'),
              subtitle: Text(formatDate(selectedDate)),
              trailing: IconButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            TextField(controller: descriptionCtrl, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Mô tả')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final price = int.tryParse(_digitsOnly(priceCtrl.text));
                if (nameCtrl.text.trim().isEmpty || price == null || price <= 0) return;
                await context.read<TetBudgetViewModel>().updateProduct(
                      productId: product.id,
                      name: nameCtrl.text.trim(),
                      price: price,
                      date: selectedDate,
                      description: descriptionCtrl.text.trim(),
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _confirmDeleteProduct(BuildContext context, TetProduct product) async {
  final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xóa sản phẩm'),
          content: Text('Bạn có chắc muốn xóa "${product.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
          ],
        ),
      ) ??
      false;

  if (!ok || !context.mounted) return;
  await context.read<TetBudgetViewModel>().deleteProduct(product.id);
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (sum, value) => sum + value);
    if (total <= 0) return;

    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = math.min(size.width, size.height) / 2;
    final stroke = radius * 0.45;
    double start = -math.pi / 2;

    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = colors[i];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius - stroke / 2), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors;
  }
}

String _digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

String formatMoney(int value) {
  final str = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    final reversedIndex = str.length - i;
    buffer.write(str[i]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
