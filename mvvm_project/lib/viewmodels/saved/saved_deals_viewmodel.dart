import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Model đơn giản cho một Deal được bookmark
class SavedDeal {
  final String id;
  final String name;
  final int price;
  final String storeName;
  final dynamic icon; // IconData
  final String imageUrl;

  const SavedDeal({
    required this.id,
    required this.name,
    required this.price,
    required this.storeName,
    required this.icon,
    this.imageUrl = '',
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'price': price,
        'storeName': storeName,
        'imageUrl': imageUrl,
      };
}

class SavedDealsViewModel extends ChangeNotifier {
  final List<SavedDeal> _savedDeals = [];
  String? _userId;
  bool _loaded = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<SavedDeal> get savedDeals => List.unmodifiable(_savedDeals);

  CollectionReference<Map<String, dynamic>>? get _savedDealsRef {
    if (_userId == null) return null;
    return _db.collection('users').doc(_userId).collection('saved_deals');
  }

  /// Call this after login to bind the ViewModel to the user and load data.
  Future<void> loadForUser(String userId) async {
    if (_userId == userId && _loaded) return;
    _userId = userId;
    _loaded = false;
    _savedDeals.clear();
    notifyListeners();
    await _fetchFromFirestore();
  }

  Future<void> _fetchFromFirestore() async {
    final ref = _savedDealsRef;
    if (ref == null) return;
    try {
      final snap = await ref.get();
      _savedDeals.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        _savedDeals.add(SavedDeal(
          id: doc.id,
          name: data['name'] as String? ?? '',
          price: (data['price'] as num?)?.toInt() ?? 0,
          storeName: data['storeName'] as String? ?? '',
          icon: null,
          imageUrl: data['imageUrl'] as String? ?? '',
        ));
      }
      _loaded = true;
    } catch (_) {}
    notifyListeners();
  }

  bool isSaved(String dealId) => _savedDeals.any((d) => d.id == dealId);

  Future<void> toggleSave(SavedDeal deal) async {
    if (isSaved(deal.id)) {
      _savedDeals.removeWhere((d) => d.id == deal.id);
      notifyListeners();
      await _savedDealsRef?.doc(deal.id).delete();
    } else {
      _savedDeals.add(deal);
      notifyListeners();
      await _savedDealsRef?.doc(deal.id).set(deal.toFirestore());
    }
  }

  Future<void> removeDeal(String dealId) async {
    _savedDeals.removeWhere((d) => d.id == dealId);
    notifyListeners();
    await _savedDealsRef?.doc(dealId).delete();
  }

  Future<void> clearAll() async {
    final ref = _savedDealsRef;
    if (ref == null) return;
    final snap = await ref.get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    _savedDeals.clear();
    notifyListeners();
  }
}
