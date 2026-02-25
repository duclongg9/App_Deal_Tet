class TetYear {
  final String id;
  final int year;
  final int totalBudget;

  const TetYear({required this.id, required this.year, required this.totalBudget});

  TetYear copyWith({String? id, int? year, int? totalBudget}) {
    return TetYear(
      id: id ?? this.id,
      year: year ?? this.year,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }
}

class TetCategory {
  final String id;
  final String yearId;
  final String name;
  final int budget;

  const TetCategory({
    required this.id,
    required this.yearId,
    required this.name,
    required this.budget,
  });
}

class TetProduct {
  final String id;
  final String categoryId;
  final String name;
  final int price;
  final DateTime date;
  final String imagePath;
  final String receiptImagePath;
  final String description;

  const TetProduct({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.date,
    required this.imagePath,
    required this.receiptImagePath,
    required this.description,
  });
}
