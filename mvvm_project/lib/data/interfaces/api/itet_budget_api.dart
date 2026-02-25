import 'package:mvvm_project/data/dtos/tet/tet_budget_bundle_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_category_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_product_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_year_dto.dart';

abstract class ITetBudgetApi {
  Future<TetBudgetBundleDto> fetchBundle();

  Future<TetYearDto> createYear({required int year, required int totalBudget});

  Future<TetCategoryDto> createCategory({
    required String yearId,
    required String name,
    required int budget,
  });

  Future<TetCategoryDto> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  });

  Future<void> deleteCategory({required String categoryId});

  Future<TetProductDto> createProduct({
    required String categoryId,
    required String name,
    required int price,
    required DateTime date,
    required String imagePath,
    required String receiptImagePath,
    required String description,
  });

  Future<TetProductDto> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  });

  Future<void> deleteProduct({required String productId});
}
