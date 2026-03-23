import 'package:flutter/material.dart';
import 'package:mvvm_project/data/interfaces/repositories/ifutter_overview_repository.dart';
import 'package:mvvm_project/domain/entities/flutter_overview/flutter_theory_topic.dart';

class FlutterOverviewViewModel extends ChangeNotifier {
  final IFlutterOverviewRepository _repository;

  FlutterOverviewViewModel(this._repository);

  final List<FlutterTheoryTopic> _topics = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FlutterTheoryTopic> get topics => List.unmodifiable(_topics);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTopics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getTopics();
      _topics
        ..clear()
        ..addAll(result);
    } catch (_) {
      _errorMessage = 'Không thể tải nội dung Flutter Overview.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
