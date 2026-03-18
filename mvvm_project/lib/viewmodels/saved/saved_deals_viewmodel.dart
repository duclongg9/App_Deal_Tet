import 'package:flutter/foundation.dart';

/// Model đơn giản cho một Deal được bookmark
class SavedDeal {
  final String id;
  final String name;
  final int price;
  final String storeName;
  final dynamic icon; // IconData

  const SavedDeal({
    required this.id,
    required this.name,
    required this.price,
    required this.storeName,
    required this.icon,
  });
}

class SavedDealsViewModel extends ChangeNotifier {
  final List<SavedDeal> _savedDeals = [];

  List<SavedDeal> get savedDeals => List.unmodifiable(_savedDeals);

  bool isSaved(String dealId) => _savedDeals.any((d) => d.id == dealId);

  void toggleSave(SavedDeal deal) {
    if (isSaved(deal.id)) {
      _savedDeals.removeWhere((d) => d.id == deal.id);
    } else {
      _savedDeals.add(deal);
    }
    notifyListeners();
  }

  void removeDeal(String dealId) {
    _savedDeals.removeWhere((d) => d.id == dealId);
    notifyListeners();
  }
}
