import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../config/legal_documents.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.document,
  });

  final LegalDocument document;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  late final Future<String> _contentFuture =
      DefaultAssetBundle.of(context).loadString(widget.document.assetPath);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;
    final horizontalPadding = isDesktop ? AppSpacing.xxxl : AppSpacing.xl;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/');
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Text(
                  'No hemos podido cargar este documento. Inténtalo de nuevo más tarde.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: AppColors.error),
                ),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.xl,
                  horizontalPadding,
                  AppSpacing.massive,
                ),
                child: MarkdownBody(
                  data: snapshot.data!,
                  selectable: true,
                  styleSheet: _markdownStyleSheet(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  MarkdownStyleSheet _markdownStyleSheet() {
    return MarkdownStyleSheet(
      h1: AppTypography.headingLarge,
      h2: AppTypography.headingMedium,
      h3: AppTypography.headingSmall,
      p: AppTypography.body.copyWith(height: 1.6),
      listBullet: AppTypography.body,
      strong: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      blockSpacing: AppSpacing.md,
      listIndent: AppSpacing.lg,
      a: AppTypography.body.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
