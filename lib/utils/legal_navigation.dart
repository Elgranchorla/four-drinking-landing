import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLegalLink(BuildContext context, String url) async {
  final uri = Uri.parse(url);

  if (uri.hasScheme) {
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return;
  }

  if (!context.mounted) return;

  final path = uri.path.isEmpty ? '/' : uri.path;
  context.push(path);
}
