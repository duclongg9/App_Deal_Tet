import 'package:flutter/material.dart';

IconData flutterTopicIcon(String iconName) {
  switch (iconName) {
    case 'widgets':
      return Icons.widgets;
    case 'grid_view':
      return Icons.grid_view;
    case 'alt_route':
      return Icons.alt_route;
    case 'sync_alt':
      return Icons.sync_alt;
    case 'cloud_download':
      return Icons.cloud_download;
    case 'storage':
      return Icons.storage;
    case 'palette':
      return Icons.palette;
    default:
      return Icons.help_outline;
  }
}
