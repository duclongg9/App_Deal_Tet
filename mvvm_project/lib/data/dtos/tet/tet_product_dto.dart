class TetProductDto {
  final String id;
  final String categoryId;
  final String name;
  final int price;
  final DateTime date;
  final String imagePath;
  final String receiptImagePath;
  final String description;

  const TetProductDto({
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
