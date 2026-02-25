import 'package:flutter/foundation.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';

class TetBudgetViewModel extends ChangeNotifier {
  final List<TetYear> _years = [];
  final List<TetCategory> _categories = [];
  final List<TetProduct> _products = [];

  String? _selectedYearId;
  int _seed = 0;

  List<TetYear> get years => List.unmodifiable(_years);
  List<TetCategory> get categories => List.unmodifiable(_categories);
  List<TetProduct> get products => List.unmodifiable(_products);

  TetYear? get selectedYear {
    if (_selectedYearId == null) return null;
    return _years.where((year) => year.id == _selectedYearId).firstOrNull;
  }

  void ensureSeedData() {
    if (_years.isNotEmpty) return;

    final year = createYear(year: DateTime.now().year, totalBudget: 6000000, silent: true);
    createCategory(yearId: year.id, name: 'Bánh kẹo', budget: 1000000, silent: true);
    createCategory(yearId: year.id, name: 'Lì xì', budget: 2000000, silent: true);
    createCategory(yearId: year.id, name: 'Trang trí', budget: 1500000, silent: true);

    final candyCategory = categoriesByYear(year.id).firstWhere((e) => e.name == 'Bánh kẹo');
    final luckyMoneyCategory = categoriesByYear(year.id).firstWhere((e) => e.name == 'Lì xì');

    addProduct(
      categoryId: candyCategory.id,
      name: 'Hộp mứt ABC',
      price: 450000,
      date: DateTime(DateTime.now().year, 1, 26),
      imagePath: '',
      receiptImagePath: '',
      description: 'Siêu thị X',
      silent: true,
    );
    addProduct(
      categoryId: luckyMoneyCategory.id,
      name: 'Bao lì xì vàng',
      price: 300000,
      date: DateTime(DateTime.now().year, 1, 20),
      imagePath: '',
      receiptImagePath: '',
      description: 'Nhà sách Y',
      silent: true,
    );

    notifyListeners();
  }

  TetYear createYear({required int year, required int totalBudget, bool silent = false}) {
    final newYear = TetYear(id: _nextId('year'), year: year, totalBudget: totalBudget);
    _years.add(newYear);
    _selectedYearId ??= newYear.id;
    if (!silent) notifyListeners();
    return newYear;
  }

  TetCategory createCategory({
    required String yearId,
    required String name,
    required int budget,
    bool silent = false,
  }) {
    final category = TetCategory(id: _nextId('cat'), yearId: yearId, name: name, budget: budget);
    _categories.add(category);
    if (!silent) notifyListeners();
    return category;
  }

  void addProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
    bool silent = false,
  }) {
    _products.add(
      TetProduct(
        id: _nextId('prod'),
        categoryId: categoryId,
        name: name,
        price: price,
        date: date,
        imagePath: imagePath,
        receiptImagePath: receiptImagePath,
        description: description,
      ),
    );
    if (!silent) notifyListeners();
  }

  void selectYear(String? id) {
    _selectedYearId = id;
    notifyListeners();
  }

  List<TetCategory> categoriesByYear(String yearId) {
    return _categories.where((category) => category.yearId == yearId).toList();
  }

  List<TetProduct> productsByCategory(String categoryId) {
    final items = _products.where((product) => product.categoryId == categoryId).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  int spentByCategory(String categoryId) {
    return _products
        .where((product) => product.categoryId == categoryId)
        .fold(0, (sum, product) => sum + product.price);
  }

  int spentByYear(String yearId) {
    final categoryIds = categoriesByYear(yearId).map((e) => e.id).toSet();
    return _products
        .where((product) => categoryIds.contains(product.categoryId))
        .fold(0, (sum, product) => sum + product.price);
  }

  int totalCategoryBudgetByYear(String yearId) {
    return categoriesByYear(yearId).fold(0, (sum, category) => sum + category.budget);
  }

  List<TetProduct> recentProductsByYear(String yearId, {int limit = 5}) {
    final categoryIds = categoriesByYear(yearId).map((e) => e.id).toSet();
    final items = _products.where((product) => categoryIds.contains(product.categoryId)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (items.length <= limit) return items;
    return items.take(limit).toList();
  }

  TetCategory? categoryById(String id) {
    return _categories.where((category) => category.id == id).firstOrNull;
  }

  String _nextId(String prefix) {
    _seed += 1;
    return '$prefix-$_seed';
  }
}
