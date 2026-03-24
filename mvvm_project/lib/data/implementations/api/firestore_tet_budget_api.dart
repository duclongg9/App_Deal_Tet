import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvvm_project/data/dtos/tet/tet_budget_bundle_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_category_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_product_dto.dart';
import 'package:mvvm_project/data/dtos/tet/tet_year_dto.dart';
import 'package:mvvm_project/data/interfaces/api/itet_budget_api.dart';

/// Firestore implementation of ITetBudgetApi.
/// All data is scoped to a single user via [userId].
///
/// Firestore structure:
///   users/{userId}/tet_years/{yearId}
///   users/{userId}/tet_categories/{categoryId}
///   users/{userId}/tet_products/{productId}
class FirestoreTetBudgetApi implements ITetBudgetApi {
  final String userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreTetBudgetApi({required this.userId});

  CollectionReference<Map<String, dynamic>> get _years =>
      _db.collection('users').doc(userId).collection('tet_years');

  CollectionReference<Map<String, dynamic>> get _categories =>
      _db.collection('users').doc(userId).collection('tet_categories');

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('users').doc(userId).collection('tet_products');

  @override
  Future<TetBudgetBundleDto> fetchBundle() async {
    final yearsSnap = await _years.orderBy('year').get();
    final categoriesSnap = await _categories.get();
    final productsSnap = await _products.get();

    final years = yearsSnap.docs.map((doc) {
      final data = doc.data();
      return TetYearDto(
        id: doc.id,
        year: (data['year'] as num).toInt(),
        totalBudget: (data['totalBudget'] as num).toInt(),
      );
    }).toList();

    final categories = categoriesSnap.docs.map((doc) {
      final data = doc.data();
      return TetCategoryDto(
        id: doc.id,
        yearId: data['yearId'] as String,
        name: data['name'] as String,
        budget: (data['budget'] as num).toInt(),
      );
    }).toList();

    final products = productsSnap.docs.map((doc) {
      final data = doc.data();
      return TetProductDto(
        id: doc.id,
        categoryId: data['categoryId'] as String,
        name: data['name'] as String,
        price: (data['price'] as num).toInt(),
        date: (data['date'] as Timestamp).toDate(),
        imagePath: data['imagePath'] as String? ?? '',
        receiptImagePath: data['receiptImagePath'] as String? ?? '',
        description: data['description'] as String? ?? '',
      );
    }).toList();

    return TetBudgetBundleDto(
      years: years,
      categories: categories,
      products: products,
    );
  }

  @override
  Future<TetYearDto> createYear({
    required int year,
    required int totalBudget,
  }) async {
    final ref = await _years.add({
      'year': year,
      'totalBudget': totalBudget,
    });
    return TetYearDto(id: ref.id, year: year, totalBudget: totalBudget);
  }

  @override
  Future<TetYearDto> updateYear({
    required String yearId,
    required int totalBudget,
  }) async {
    await _years.doc(yearId).update({'totalBudget': totalBudget});
    final doc = await _years.doc(yearId).get();
    final data = doc.data()!;
    return TetYearDto(
      id: yearId,
      year: (data['year'] as num).toInt(),
      totalBudget: totalBudget,
    );
  }

  @override
  Future<TetCategoryDto> createCategory({
    required String yearId,
    required String name,
    required int budget,
  }) async {
    final ref = await _categories.add({
      'yearId': yearId,
      'name': name,
      'budget': budget,
    });
    return TetCategoryDto(id: ref.id, yearId: yearId, name: name, budget: budget);
  }

  @override
  Future<TetCategoryDto> updateCategory({
    required String categoryId,
    required String name,
    required int budget,
  }) async {
    await _categories.doc(categoryId).update({'name': name, 'budget': budget});
    final doc = await _categories.doc(categoryId).get();
    final data = doc.data()!;
    return TetCategoryDto(
      id: categoryId,
      yearId: data['yearId'] as String,
      name: name,
      budget: budget,
    );
  }

  @override
  Future<void> deleteCategory({required String categoryId}) async {
    await _categories.doc(categoryId).delete();
    // Delete all products in this category
    final productsToDelete = await _products
        .where('categoryId', isEqualTo: categoryId)
        .get();
    final batch = _db.batch();
    for (final doc in productsToDelete.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
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
    final ref = await _products.add({
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'date': Timestamp.fromDate(date),
      'imagePath': imagePath,
      'receiptImagePath': receiptImagePath,
      'description': description,
    });
    return TetProductDto(
      id: ref.id,
      categoryId: categoryId,
      name: name,
      price: price,
      date: date,
      imagePath: imagePath,
      receiptImagePath: receiptImagePath,
      description: description,
    );
  }

  @override
  Future<TetProductDto> updateProduct({
    required String productId,
    required String name,
    required int price,
    required DateTime date,
    required String description,
  }) async {
    await _products.doc(productId).update({
      'name': name,
      'price': price,
      'date': Timestamp.fromDate(date),
      'description': description,
    });
    final doc = await _products.doc(productId).get();
    final data = doc.data()!;
    return TetProductDto(
      id: productId,
      categoryId: data['categoryId'] as String,
      name: name,
      price: price,
      date: date,
      imagePath: data['imagePath'] as String? ?? '',
      receiptImagePath: data['receiptImagePath'] as String? ?? '',
      description: description,
    );
  }

  @override
  Future<void> deleteProduct({required String productId}) async {
    await _products.doc(productId).delete();
  }
}
