import 'package:mvvm_project/data/dtos/tet/tet_budget_bundle_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_category_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_product_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_year_dto.dart';
import 'package:mvvm_project/data/interfaces/api/itet_budget_api.dart';

class MockTetBudgetApi implements ITetBudgetApi {
  final List<TetYearDto> _years = [];
  final List<TetCategoryDto> _categories = [];
  final List<TetProductDto> _products = [];

  int _seed = 0;

  @override
  Future<TetBudgetBundleDto> fetchBundle() async {
    return TetBudgetBundleDto(
      years: List<TetYearDto>.from(_years),
      categories: List<TetCategoryDto>.from(_categories),
      products: List<TetProductDto>.from(_products),
    );
  }

  @override
  Future<TetYearDto> createYear({required int year, required int totalBudget}) async {
    final item = TetYearDto(id: _nextId('year'), year: year, totalBudget: totalBudget);
    _years.add(item);
    return item;
  }

  @override
  Future<TetCategoryDto> createCategory({
    required String yearId,
    required String name,
    required int budget,
  }) async {
    final item = TetCategoryDto(
      id: _nextId('cat'),
      yearId: yearId,
      name: name,
      budget: budget,
    );
    _categories.add(item);
    return item;
  }

  @override
  Future<TetCategoryDto> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  }) async {
    final idx = _categories.indexWhere((e) => e.id == categoryId);
    if (idx < 0) throw Exception('Không tìm thấy hạng mục.');
    final old = _categories[idx];
    final item = TetCategoryDto(id: old.id, yearId: old.yearId, name: name, budget: budget);
    _categories[idx] = item;
    return item;
  }

  @override
  Future<void> deleteCategory({required String categoryId}) async {
    _categories.removeWhere((e) => e.id == categoryId);
    _products.removeWhere((e) => e.categoryId == categoryId);
  }

  @override
  Future<TetProductDto> createProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
  }) async {
    final item = TetProductDto(
      id: _nextId('prod'),
      categoryId: categoryId,
      name: name,
      price: price,
      date: date,
      imagePath: imagePath,
      receiptImagePath: receiptImagePath,
      description: description,
    );
    _products.add(item);
    return item;
  }

  @override
  Future<TetProductDto> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  }) async {
    final idx = _products.indexWhere((e) => e.id == productId);
    if (idx < 0) throw Exception('Không tìm thấy sản phẩm.');
    final old = _products[idx];
    final item = TetProductDto(
      id: old.id,
      categoryId: old.categoryId,
      name: name,
      price: price,
      date: date,
      imagePath: old.imagePath,
      receiptImagePath: old.receiptImagePath,
      description: description,
    );
    _products[idx] = item;
    return item;
  }

  @override
  Future<void> deleteProduct({required String productId}) async {
    _products.removeWhere((e) => e.id == productId);
  }

  String _nextId(String prefix) {
    _seed += 1;
    return '$prefix-$_seed';
  }
}
