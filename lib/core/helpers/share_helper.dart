import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../shared/custom_snack_bar.dart';

class ShareHelper {

  static Future<void> shareAsImage(
      BuildContext context,
      String content, {
        required bool isDark,
        String? category,
        String? source,
        String? fontFamily,
      }) async {
    _showLoadingDialog(context);

    OverlayEntry? entry;

    try {
      final ByteData logoData = await rootBundle.load('assets/icons/loogo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();

      final GlobalKey repaintKey = GlobalKey();
      final overlay = Overlay.of(context);

      entry = OverlayEntry(
        builder: (_) => Positioned(
          top: -6000,
          left: 0,
          child: Material(
            color: Colors.transparent,
            child: RepaintBoundary(
              key: repaintKey,
              child: _ShareCard(
                content: content,
                logoBytes: logoBytes,
                category: category,
                source: source,
                isDark: isDark,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ),
      );

      overlay.insert(entry);

      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 120));
      await WidgetsBinding.instance.endOfFrame;

      final renderObject = repaintKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw Exception('Card render failed');
      }

      final uiImage = await renderObject.toImage(pixelRatio: 3.0);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to encode image');

      final dir = await getTemporaryDirectory();
      await dir.create(recursive: true);

      final filePath =
          '${dir.path}/hisn_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      if (context.mounted) {
        _dismissDialog(context);

        await Share.shareXFiles(
          [XFile(file.path)],
          sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 2,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('ShareHelper Error: $e');
      debugPrint('StackTrace: $stackTrace');

      if (context.mounted) {
        _dismissDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            'حدث خطأ أثناء مشاركة الصورة، حاول مرة أخرى',
            Icons.info,
            context,
          ),
        );
      }
    } finally {
      entry?.remove();
    }
  }
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => Center(
        child: CupertinoActivityIndicator(color: Colors.teal.shade700),
      ),
    );
  }

  static void _dismissDialog(BuildContext context) {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

// ─── Palette (Manuscript / Illuminated page identity) — فاتح وداكن

class _SharePalette {
  final Color paper;
  final Color ink;
  final Color gold;
  final Color teal;
  final Color tealTint;
  final Color muted;
  final Color logoRing;

  const _SharePalette({
    required this.paper,
    required this.ink,
    required this.gold,
    required this.teal,
    required this.tealTint,
    required this.muted,
    required this.logoRing,
  });

  factory _SharePalette.of(bool isDark) {
    if (isDark) {
      return const _SharePalette(
        paper: Color(0xFF141B17),
        ink: Color(0xFFF2EFE6),
        gold: Color(0xFFD4B573),
        teal: Color(0xFF56C2A8),
        tealTint: Color(0xFF1C2924),
        muted: Color(0xFFA6ADA5),
        logoRing: Color(0xFF223229),
      );
    }
    return const _SharePalette(
      paper: Color(0xFFFBF7EF),
      ink: Color(0xFF1E2B23),
      gold: Color(0xFFB4923F),
      teal: Color(0xFF0F6E5B),
      tealTint: Color(0xFFE9F2EF),
      muted: Color(0xFF7A8078),
      logoRing: Color(0xFF96A996),
    );
  }
}

// ─── Share Card

class _ShareCard extends StatelessWidget {
  final String content;
  final String? fontFamily;
  final Uint8List logoBytes;
  final String? category;
  final String? source;
  final bool isDark;

  const _ShareCard({
    required this.content,
    required this.logoBytes,
    required this.isDark,
    this.category,
    this.source,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _SharePalette.of(isDark);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 400,
        color: palette.paper,
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: palette.gold.withValues(alpha: 0.55),
              width: 1.4,
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: palette.gold.withValues(alpha: 0.28),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // _AppSignature(logoBytes: logoBytes, palette: palette),
                // const Gap(14),
                if (category != null) ...[
                  _CategoryChip(label: category!, palette: palette),
                  const Gap(20),
                ],
                _OrnamentDivider(palette: palette),
                const Gap(24),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: fontFamily ?? 'QuranFont',
                    fontSize: 20,
                    height: 1.8,
                    color: palette.ink,
                  ),
                ),
                const Gap(24),
                _OrnamentDivider(palette: palette),
                if (source != null) ...[
                  const Gap(14),
                  Text(
                    source!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Noon',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.muted,
                    ),
                  ),
                ],
                const Gap(22),
                // Container(height: 1, color: palette.gold.withValues(alpha: 0.22)),
                // const Gap(14),

                _AppSignature(logoBytes: logoBytes, palette: palette),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Category Chip

class _CategoryChip extends StatelessWidget {
  final String label;
  final _SharePalette palette;
  const _CategoryChip({required this.label, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: palette.tealTint,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: palette.teal.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Noon',
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: palette.teal,
          height: 1,
        ),
      ),
    );
  }
}

// ─── Ornament Divider

class _OrnamentDivider extends StatelessWidget {
  final _SharePalette palette;
  const _OrnamentDivider({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: palette.gold.withValues(alpha: 0.45)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(width: 7, height: 7, color: palette.gold),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: palette.gold.withValues(alpha: 0.45)),
        ),
      ],
    );
  }
}

//─── App Signature

class _AppSignature extends StatelessWidget {
  final Uint8List logoBytes;
  final _SharePalette palette;
  const _AppSignature({required this.logoBytes, required this.palette});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color:
              isDark ? Colors.transparent :
          Colors.white, shape:
          BoxShape.circle ,
              border: Border.all(
                color: Color(0xFFB4923F).withValues(alpha: 0.43),
              )
          ),
          child: ClipOval(
            child: Image.memory(logoBytes, width: 40.w, height: 40.h, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}