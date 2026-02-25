import 'package:mvvm_project/data/dtos/tet/tet_budget_bundle_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_category_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_product_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_year_dto.dart';
import 'package:mvvm_project/data/interfaces/repositories/itet_budget_repository.dart';
import 'package:mvvm_project/domain/entities/tet_models.dart';

class TetBudgetMapper {
  TetBudgetBundle toBundle(TetBudgetBundleDto dto) {
    return TetBudgetBundle(
      years: dto.years.map(toYear).toList(growable: false),
      categories: dto.categories.map(toCategory).toList(growable: false),
      products: dto.products.map(toProduct).toList(growable: false),
    );
  }

  TetYear toYear(TetYearDto dto) =>
      TetYear(id: dto.id, year: dto.year, totalBudget: dto.totalBudget);

  TetCategory toCategory(TetCategoryDto dto) => TetCategory(
        id: dto.id,
        yearId: dto.yearId,
        name: dto.name,
        budget: dto.budget,
      );

  TetProduct toProduct(TetProductDto dto) => TetProduct(
        id: dto.id,
        categoryId: dto.categoryId,
        name: dto.name,
        price: dto.price,
        date: dto.date,
        imagePath: dto.imagePath,
        receiptImagePath: dto.receiptImagePath,
        description: dto.description,
      );
}
