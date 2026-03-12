import 'package:mvvm_project/domain/entities/flutter_overview/flutter_theory_topic.dart';

abstract class IFlutterOverviewRepository {
  Future<List<FlutterTheoryTopic>> getTopics();
}
