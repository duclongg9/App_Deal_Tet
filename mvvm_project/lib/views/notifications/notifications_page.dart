import 'package:flutter/material.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';
import 'package:mvvm_project/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetColors.bgMain,
      appBar: AppBar(
        backgroundColor: TetColors.bgMain,
        elevation: 0,
        title: const Text('Thông Báo 🏮',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: TetColors.textPrimary)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: TetColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<NotificationsViewModel>(
            builder: (ctx, vm, _) => vm.notifications.isNotEmpty
                ? TextButton(
                    onPressed: () => vm.markAllAsRead(),
                    child: const Text('Đọc tất cả', style: TextStyle(color: TetColors.festiveRed)),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, vm, _) {
          final notifications = vm.notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 72, color: TetColors.textMuted),
                  SizedBox(height: 12),
                  Text('Không có thông báo nào',
                      style: TextStyle(color: TetColors.textSecondary, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final note = notifications[index];
              return Dismissible(
                key: Key(note.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: TetColors.danger.withOpacity(0.1),
                  child: const Icon(Icons.delete_outline, color: TetColors.danger),
                ),
                onDismissed: (_) => vm.deleteNotification(note.id),
                child: _buildNotificationItem(context, note, vm),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, AppNotification note, NotificationsViewModel vm) {
    IconData iconData;
    Color iconColor;

    switch (note.type) {
      case NotificationType.gift:
        iconData = Icons.card_giftcard;
        iconColor = TetColors.festiveRed;
        break;
      case NotificationType.sale:
        iconData = Icons.local_fire_department;
        iconColor = TetColors.accentGold;
        break;
      case NotificationType.warning:
        iconData = Icons.warning_amber_outlined;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.check_circle_outline;
        iconColor = TetColors.success;
    }

    return InkWell(
      onTap: () => vm.markAsRead(note.id),
      child: Container(
        padding: const EdgeInsets.all(TetSpacing.s4),
        decoration: BoxDecoration(
          color: note.isRead ? Colors.transparent : TetColors.primary50.withOpacity(0.4),
          border: Border(bottom: BorderSide(color: TetColors.border.withOpacity(0.5))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: TetSpacing.s4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(note.title,
                            style: TextStyle(
                              fontWeight: note.isRead ? FontWeight.bold : FontWeight.w900,
                              fontSize: 14, color: TetColors.textPrimary,
                            )),
                      ),
                      if (!note.isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: TetColors.festiveRed, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(note.body,
                      style: const TextStyle(color: TetColors.textSecondary, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(_timeAgo(note.createdAt),
                      style: const TextStyle(color: TetColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
