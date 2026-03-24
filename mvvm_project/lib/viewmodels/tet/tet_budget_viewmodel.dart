import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/interfaces/repositories/itet_budget_repository.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';

class TetBudgetViewModel extends ChangeNotifier {
  final ITetBudgetRepository repo;
  final String firestoreUserId;

  TetBudgetViewModel(this.repo, {this.firestoreUserId = 'anonymous'});

  final List<TetYear> _years = [];
  final List<TetCategory> _categories = [];
  final List<TetProduct> _products = [];

  String? _selectedYearId;
  bool isLoading = false;

  List<TetYear> get years => List.unmodifiable(_years);
  List<TetCategory> get categories => List.unmodifiable(_categories);
  List<TetProduct> get products => List.unmodifiable(_products);

  TetYear? get selectedYear {
    if (_selectedYearId == null) return null;
    return _years.where((year) => year.id == _selectedYearId).firstOrNull;
  }

  Future<void> ensureSeedData() async {
    if (_years.isNotEmpty) return;
    
    isLoading = true;
    notifyListeners();

    await _reload();

    isLoading = false;
    notifyListeners();
  }

  Future<TetYear> createYear({
    required int year,
    required int totalBudget,
    bool silent = false,
  }) async {
    final newYear = await repo.createYear(year: year, totalBudget: totalBudget);
    _years.add(newYear);
    _selectedYearId ??= newYear.id;
    if (!silent) notifyListeners();
    return newYear;
  }

  Future<TetCategory> createCategory({
    required String yearId,
    required String name,
    required int budget,
    bool silent = false,
  }) async {
    final category = await repo.createCategory(yearId: yearId, name: name, budget: budget);
    _categories.add(category);
    if (!silent) notifyListeners();
    return category;
  }

  Future<void> addProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
    bool silent = false,
  }) async {
    final product = await repo.createProduct(
      categoryId: categoryId,
      name: name,
      price: price,
      date: date,
      imagePath: imagePath,
      receiptImagePath: receiptImagePath,
      description: description,
    );

    _products.add(product);
    if (!silent) notifyListeners();
  }

  void selectYear(String? id) {
    _selectedYearId = id;
    notifyListeners();
  }

  Future<void> updateYear({required String yearId, required int totalBudget}) async {
    final updated = await repo.updateYear(yearId: yearId, totalBudget: totalBudget);
    final idx = _years.indexWhere((y) => y.id == yearId);
    if (idx >= 0) {
      _years[idx] = updated;
      notifyListeners();
    }
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

  List<TetProduct> recentProductsByYear(String yearId, {int? limit}) {
    final categoryIds = categoriesByYear(yearId).map((e) => e.id).toSet();
    final items = _products.where((product) => categoryIds.contains(product.categoryId)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (limit == null || items.length <= limit) return items;
    return items.take(limit).toList();
  }



  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  }) async {
    final updated = await repo.updateCategory(categoryId: categoryId, name: name, budget: budget);
    final idx = _categories.indexWhere((item) => item.id == categoryId);
    if (idx >= 0) {
      _categories[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    await repo.deleteCategory(categoryId: categoryId);
    _categories.removeWhere((item) => item.id == categoryId);
    _products.removeWhere((item) => item.categoryId == categoryId);
    notifyListeners();
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  }) async {
    final updated = await repo.updateProduct(
      productId: productId,
      name: name,
      price: price,
      date: date,
      description: description,
    );
    final idx = _products.indexWhere((item) => item.id == productId);
    if (idx >= 0) {
      _products[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await repo.deleteProduct(productId: productId);
    _products.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  TetCategory? categoryById(String id) {
    return _categories.where((category) => category.id == id).firstOrNull;
  }

  Future<void> _reload() async {
    try {
      final bundle = await repo.fetchBundle();
      _years
        ..clear()
        ..addAll(bundle.years);
      _categories
        ..clear()
        ..addAll(bundle.categories);
      _products
        ..clear()
        ..addAll(bundle.products);

      // Auto-select the year matching the current calendar year, fallback to first
      if (_selectedYearId == null && _years.isNotEmpty) {
        final currentYear = DateTime.now().year;
        final match = _years.where((y) => y.year == currentYear).firstOrNull;
        _selectedYearId = (match ?? _years.first).id;
      }
      notifyListeners();
    } catch (e) {
      // Firestore not yet enabled or network error — app continues gracefully
      // ignore: avoid_print
      print('[TetBudgetVM] _reload error (is Firestore enabled?): $e');
    }
  }
}

