import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static final ScreenshotController _screenshotController =
      ScreenshotController();

  static Future<void> shareAsImage(BuildContext context, String content) async {
    // Show loading overlay
    _showLoadingDialog(context);

    try {
      // ✅ Fix 1: Load asset image bytes BEFORE captureFromWidget
      // Image.asset doesn't work outside the widget tree
      final ByteData logoData = await rootBundle.load('assets/icons/loogo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();

      // Capture the widget at a fixed logical size
      final imageBytes = await _screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 800),
            devicePixelRatio: 1.0,
          ),
          child: _ShareCard(
            content: content,
            logoBytes: logoBytes, // ✅ Pass pre-loaded image bytes
          ),
        ),
        delay: const Duration(milliseconds: 500),
        pixelRatio: 3.0,
      );

      // ✅ Fix 2: Ensure temp directory exists before writing
      final dir = await getTemporaryDirectory();
      await dir.create(recursive: true);

      final filePath =
          '${dir.path}/hisn_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      if (context.mounted) {
        _dismissDialog(context);

        // ✅ Fix 3: Add sharePositionOrigin for iOS compatibility
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
      // ✅ Fix 4: Print real error for debugging
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

// ─── Share Card ────────────────────────────────────────────────────────────────

class _ShareCard extends StatelessWidget {
  final String content;
  final Uint8List logoBytes; // ✅ Receive pre-loaded logo bytes

  const _ShareCard({required this.content, required this.logoBytes});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D2137), Color(0xFF1B4332), Color(0xFF0D2137)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            const Positioned(
              top: -40,
              left: -40,
              child: _DecoCircle(size: 180, opacity: 0.06),
            ),
            const Positioned(
              bottom: -30,
              right: -30,
              child: _DecoCircle(size: 160, opacity: 0.06),
            ),
            const Positioned(
              top: 80,
              right: -20,
              child: _DecoCircle(size: 100, opacity: 0.04),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 28),
                  _AppHeader(logoBytes: logoBytes), // ✅ Pass logo bytes down

                  const SizedBox(height: 28),

                  // Content Card
                  _ContentCard(content: content),

                  const Gap(28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Decorative Circle ─────────────────────────────────────────────────────────

class _DecoCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecoCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity),
          width: 1.5,
        ),
      ),
    );
  }
}

// ─── App Header ───────────────────────────────────────────────────────────────

class _AppHeader extends StatelessWidget {
  final Uint8List
  logoBytes; // ✅ Receive logo bytes instead of using Image.asset

  const _AppHeader({required this.logoBytes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              // ✅ Fix: Use Image.memory instead of Image.asset
              // Image.asset fails outside the widget tree (captureFromWidget)
              child: Image.memory(logoBytes, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Content Card ─────────────────────────────────────────────────────────────

class _ContentCard extends StatelessWidget {
  final String content;

  const _ContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Noon',
          fontSize: 19,
          height: 1.4,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}
