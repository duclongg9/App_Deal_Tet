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

  Future<TetCategory> createCategory({
    required String yearId,
    required String name,
    required int budget,
  });

  Future<TetProduct> createProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
  });
}
