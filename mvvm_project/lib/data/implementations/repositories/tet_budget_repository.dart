import 'package:mvvm_project/data/implementations/mapper/tet_budget_mapper.dart';
import 'package:mvvm_project/data/interfaces/api/itet_budget_api.dart';
import 'package:mvvm_project/data/interfaces/repositories/itet_budget_repository.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';

class TetBudgetRepository implements ITetBudgetRepository {
  final ITetBudgetApi api;
  final TetBudgetMapper mapper;

  TetBudgetRepository({required this.api, required this.mapper});

  @override
  Future<TetBudgetBundle> fetchBundle() async {
    final dto = await api.fetchBundle();
    return mapper.toBundle(dto);
  }

  @override
  Future<TetYear> createYear({required int year, required int totalBudget}) async {
    final dto = await api.createYear(year: year, totalBudget: totalBudget);
    return mapper.toYear(dto);
  }

  @override
  Future<TetYear> updateYear({required String yearId, required int totalBudget}) async {
    final dto = await api.updateYear(yearId: yearId, totalBudget: totalBudget);
    return mapper.toYear(dto);
  }

  @override
  Future<TetCategory> createCategory({
    required String yearId,
    required String name,
    required int budget,
  }) async {
    final dto = await api.createCategory(yearId: yearId, name: name, budget: budget);
    return mapper.toCategory(dto);
  }

  @override
  Future<TetCategory> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  }) async {
    final dto = await api.updateCategory(categoryId: categoryId, name: name, budget: budget);
    return mapper.toCategory(dto);
  }

  @override
  Future<void> deleteCategory({required String categoryId}) {
    return api.deleteCategory(categoryId: categoryId);
  }

  @override
  Future<TetProduct> createProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
  }) async {
    final dto = await api.createProduct(
      categoryId: categoryId,
      name: name,
      price: price,
      date: date,
      imagePath: imagePath,
      receiptImagePath: receiptImagePath,
      description: description,
    );
    return mapper.toProduct(dto);
  }

  @override
  Future<TetProduct> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  }) async {
    final dto = await api.updateProduct(
      productId: productId,
      name: name,
      price: price,
      date: date,
      description: description,
    );
    return mapper.toProduct(dto);
  }

  @override
  Future<void> deleteProduct({required String productId}) {
    return api.deleteProduct(productId: productId);
  }
}
