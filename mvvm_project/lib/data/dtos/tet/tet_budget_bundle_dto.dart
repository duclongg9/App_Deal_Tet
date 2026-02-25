import 'package:mvvm_project/data/dtos/tet/tet_category_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_product_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_year_dto.dart';

class TetBudgetBundleDto {
  final List<TetYearDto> years;
  final List<TetCategoryDto> categories;
  final List<TetProductDto> products;

  const TetBudgetBundleDto({
    required this.years,
    required this.categories,
    required this.products,
  });
}
