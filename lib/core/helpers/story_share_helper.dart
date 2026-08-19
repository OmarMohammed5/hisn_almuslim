import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';

import 'story_card_renderer.dart';
import 'story_pdf_generator.dart';
import 'story_share_data.dart';

class StoryShareHelper {
  StoryShareHelper._();

  // ============================================================
  // SHOW SHARE OPTIONS
  // ============================================================


  static String _sanitizeFileName(String name) {
    return name
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }


  static Future<void> showShareOptions(
      BuildContext context, {
        required StoryShareData data,
      }) async {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF171C1D)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // HANDLE
                // ==================================================

                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white24
                        : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'مشاركة القصة',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF171A19),
                    fontFamily: 'QuranFont',
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white54
                        : Colors.black45,
                    fontFamily: 'QuranFont',
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // CARD + PDF
                // ==================================================

                Row(
                  children: [
                    // =================================================
                    // SHARE AS CARD
                    // =================================================

                    Expanded(
                      child: _ShareOption(
                        icon: Icons.image_outlined,
                        title: 'بطاقة',
                        subtitle: 'مشاركة مختصرة',
                        accentColor: accentColor,
                        onTap: () async {
                          Navigator.pop(sheetContext);

                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );

                          await _shareAsCard(
                            context,
                            data,
                            isDark,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // =================================================
                    // SHARE AS PDF
                    // =================================================

                    Expanded(
                      child: _ShareOption(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'القصة كاملة',
                        subtitle: 'مشاركة PDF',
                        accentColor: accentColor,
                        onTap: () async {
                          Navigator.pop(sheetContext);

                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );

                          await _shareAsPdf(
                            context,
                            data,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ==================================================
                // SHARE AS TEXT
                // ==================================================

                _ShareTextOption(
                  icon: Icons.text_snippet_outlined,
                  title: 'مشاركة كنص',
                  subtitle: 'مشاركة القصة كاملة كنص',
                  accentColor: accentColor,
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    await Future.delayed(
                      const Duration(milliseconds: 200),
                    );

                    await _shareAsText(data);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SHARE AS TEXT
  // ============================================================

  static Future<void> _shareAsText(
      StoryShareData data,
      ) async {
    final text = '''
${data.title}

${data.content}

${data.category}
حصن المسلم
''';

    await Share.share(text);
  }

  // ============================================================
  // SHARE AS PDF
  // ============================================================

  static Future<void> _shareAsPdf(
      BuildContext context,
      StoryShareData data,
      ) async {
    try {
      _showLoading(
        context,
        'جاري تجهيز القصة...',
      );

      final Uint8List pdfBytes = await StoryPdfGenerator.generate(
        story: data.story,
        currentIndex: data.currentIndex,
        totalStories: data.totalStories,
      );

      final directory = Directory.systemTemp;

      final safeTitle = _sanitizeFileName('قصة ${data.title}');

      final fileName = '$safeTitle.pdf';

      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(pdfBytes, flush: true);

      if (!context.mounted) return;

      _hideLoading(context);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${data.title} - ${data.category}',
      );
    } catch (e, stackTrace) {
      debugPrint('================ PDF ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('============================================');

      if (!context.mounted) return;

      _hideLoading(context);

      _showError(context, 'تعذر إنشاء ملف القصة');
    }
  }

  // ============================================================
  // SHARE AS CARD
  // ============================================================

  static Future<void> _shareAsCard(
      BuildContext context,
      StoryShareData data,
      bool isDark,
      ) async {
    try {
      // ==========================================================
      // SHOW LOADING
      // ==========================================================

      _showLoading(
        context,
        'جاري تجهيز البطاقة...',
      );

      // ==========================================================
      // RENDER CARD
      // ==========================================================

      final bytes = await StoryCardRenderer.render(
        context: context,
        data: data,
        isDark: isDark,
      );

      // ==========================================================
      // CREATE TEMPORARY IMAGE FILE
      // ==========================================================

      final directory = Directory.systemTemp;

      final fileName =
          'story_card_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(
        '${directory.path}/$fileName',
      );

      // ==========================================================
      // WRITE IMAGE
      // ==========================================================

      await file.writeAsBytes(
        bytes,
        flush: true,
      );

      // ==========================================================
      // CHECK CONTEXT
      // ==========================================================

      if (!context.mounted) {
        return;
      }

      // ==========================================================
      // HIDE LOADING
      // ==========================================================

      _hideLoading(context);

      // ==========================================================
      // SHARE IMAGE
      // ==========================================================

      await Share.shareXFiles(
        [
          XFile(file.path),
        ],
        text: '${data.title} - ${data.category}',
      );
    } catch (e, stackTrace) {
      // ==========================================================
      // DEBUG
      // ==========================================================

      debugPrint(
        '================ CARD SHARE ERROR ================',
      );

      debugPrint(
        'ERROR: $e',
      );

      debugPrint(
        'STACK TRACE: $stackTrace',
      );

      debugPrint(
        '===================================================',
      );

      // ==========================================================
      // CHECK CONTEXT
      // ==========================================================

      if (!context.mounted) {
        return;
      }

      // ==========================================================
      // HIDE LOADING
      // ==========================================================

      _hideLoading(context);

      // ==========================================================
      // SHOW ERROR
      // ==========================================================

      _showError(
        context,
        'تعذر إنشاء بطاقة المشاركة',
      );
    }
  }

  // ============================================================
  // SHOW LOADING
  // ============================================================

  static void _showLoading(
      BuildContext context,
      String message,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Row(
              children: [
                 SizedBox(
                  width: 22,
                  height: 22,
                  child: CupertinoActivityIndicator(
                    color: AppColors.kPrimary,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'QuranFont',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HIDE LOADING
  // ============================================================

  static void _hideLoading(
      BuildContext context,
      ) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // ============================================================
  // SHOW ERROR
  // ============================================================

  static void _showError(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'QuranFont',
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// =================================================================
// SHARE OPTION
// =================================================================

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: accentColor.withValues(
              alpha: 0.07,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          child: Column(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 23,
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // TITLE
              // ==================================================

              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? Colors.white
                      : Colors.black87,
                  fontFamily: 'QuranFont',
                ),
              ),

              const SizedBox(height: 2),

              // ==================================================
              // SUBTITLE
              // ==================================================

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark
                      ? Colors.white54
                      : Colors.black45,
                  fontFamily: 'QuranFont',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// TEXT SHARE OPTION
// =================================================================

class _ShareTextOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ShareTextOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(
              alpha: 0.04,
            )
                : Colors.black.withValues(
              alpha: 0.025,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Icon(
                icon,
                color: accentColor,
                size: 22,
              ),

              const SizedBox(width: 14),

              // ==================================================
              // TEXT
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : Colors.black87,
                        fontFamily: 'QuranFont',
                      ),
                    ),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark
                            ? Colors.white54
                            : Colors.black45,
                        fontFamily: 'QuranFont',
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // ARROW
              // ==================================================

              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 14,
                color: isDark
                    ? Colors.white38
                    : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}