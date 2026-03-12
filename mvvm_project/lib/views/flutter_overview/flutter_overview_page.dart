import 'package:flutter/material.dart';
import 'package:mvvm_project/data/implementations/repositories/flutter_overview_repository.dart';
import 'package:mvvm_project/viewmodels/flutter_overview/flutter_overview_viewmodel.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_overview_styles.dart';
import 'package:mvvm_project/views/flutter_overview/flutter_theory_detail_page.dart';
import 'package:mvvm_project/views/flutter_overview/widgets/topic_card.dart';
import 'package:provider/provider.dart';

class FlutterOverviewPage extends StatelessWidget {
  const FlutterOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlutterOverviewViewModel(FlutterOverviewRepository())..loadTopics(),
      child: const _FlutterOverviewView(),
    );
  }
}

class _FlutterOverviewView extends StatelessWidget {
  const _FlutterOverviewView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlutterOverviewViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        title: const Text('Tổng quan Flutter'),
        backgroundColor: const Color(0xFF1E4F9C),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, FlutterOverviewViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            viewModel.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Flutter là framework UI đa nền tảng dùng Dart.\n\n'
            'Trang này đã được tách theo kiến trúc (data/domain/viewmodel/view) '
            'và đọc dữ liệu lý thuyết từ file Markdown để dễ mở rộng.',
            style: summaryStyle,
          ),
        ),
        const SizedBox(height: 12),
        ...viewModel.topics.map(
          (topic) => TopicCard(
            topic: topic,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FlutterTheoryDetailPage(topic: topic),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
