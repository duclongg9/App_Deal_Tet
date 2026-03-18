import 'package:mvvm_project/domain/entities/tet_models.dart';

class TetBudgetBundle {
  final List<TetYear> years;
  final List<TetCategory> categories;
  final List<TetProduct> products;

  const TetBudgetBundle({
    required this.years,
    required this.categories,
    required this.products,
  });
}

abstract class ITetBudgetRepository {
  Future<TetBudgetBundle> fetchBundle();

  Future<TetYear> createYear({required int year, required int totalBudget});

  Future<TetYear> updateYear({required String yearId, required int totalBudget});

  Future<TetCategory> createCategory({
    required String yearId,
    required String name,
    required int budget,
  });

  Future<TetCategory> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  });

  Future<void> deleteCategory({required String categoryId});

  Future<TetProduct> createProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
  });

  Future<TetProduct> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  });

  Future<void> deleteProduct({required String productId});
}
