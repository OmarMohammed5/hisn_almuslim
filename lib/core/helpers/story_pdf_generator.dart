import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/stories/domain/entities/prophet_story.dart';

class StoryPdfGenerator {
  StoryPdfGenerator._();

  // ============================================================
  // APP COLORS
  // ============================================================

  static const PdfColor teal = PdfColor.fromInt(0xFF0F766E);

  static const PdfColor darkTeal = PdfColor.fromInt(0xFF115E59);

  static const PdfColor gold = PdfColor.fromInt(0xFFB4923F);

  static const PdfColor textColor = PdfColor.fromInt(0xFF1F2933);

  static const PdfColor secondaryText =
  PdfColor.fromInt(0xFF6B7280);

  static const PdfColor background =
  PdfColor.fromInt(0xFFF9FAF9);

  // ============================================================
  // GENERATE PDF
  // ============================================================

  static Future<Uint8List> generate({
    required ProphetStory story,
    required int currentIndex,
    required int totalStories,
  }) async {
    // ----------------------------------------------------------
    // Load Cairo fonts
    // ----------------------------------------------------------

    final regularFontData = await rootBundle.load(
      'assets/fonts/AlQuranAlKareem.ttf',
    );

    final boldFontData = await rootBundle.load(
      'assets/fonts/AlQuranAlKareem.ttf',
    );

    final regularFont = pw.Font.ttf(
      regularFontData,
    );

    final boldFont = pw.Font.ttf(
      boldFontData,
    );

    // ----------------------------------------------------------
    // Load App Logo
    // ----------------------------------------------------------

    final logoData = await rootBundle.load(
      'assets/icons/loogo.png',
    );

    final logoImage = pw.MemoryImage(
      logoData.buffer.asUint8List(),
    );

    // ----------------------------------------------------------
    // Create PDF
    // ----------------------------------------------------------

    final pdf = pw.Document(
      title: 'قصة ${story.prophet}',
      author: 'حصن المسلم',
      subject: 'قصص الأنبياء',
    );

    // ----------------------------------------------------------
    // Theme
    // ----------------------------------------------------------

    final theme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
    );

    // ----------------------------------------------------------
    // Clean Story Text
    // ----------------------------------------------------------

    final paragraphs = _prepareParagraphs(
      story.story,
    );

    // ----------------------------------------------------------
    // Add pages
    // ----------------------------------------------------------

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        theme: theme,

        textDirection: pw.TextDirection.rtl,

        margin: const pw.EdgeInsets.only(
          top: 32,
          left: 42,
          right: 42,
          bottom: 40,
        ),

        header: (context) {
          return _buildHeader(
            logoImage: logoImage,
            story: story,
            currentIndex: currentIndex,
            totalStories: totalStories,
          );
        },

        footer: (context) {
          return _buildFooter(
            context,
          );
        },

        build: (context) {
          return [
            // ==================================================
            // STORY CONTENT
            // ==================================================

            pw.SizedBox(
              height: 22,
            ),

            ...paragraphs.map(
                  (paragraph) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: pw.Text(
                    paragraph,
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 13,
                      lineSpacing: 7,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),

            // ==================================================
            // END OF STORY
            // ==================================================

            pw.SizedBox(
              height: 20,
            ),

            _buildEndDivider(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // HEADER
  // ============================================================

  static pw.Widget _buildHeader({
    required pw.ImageProvider logoImage,
    required ProphetStory story,
    required int currentIndex,
    required int totalStories,
  }) {
    final progress =
    totalStories > 0
        ? (currentIndex + 1) / totalStories
        : 0.0;

    return pw.Column(
      children: [
        // ------------------------------------------------------
        // Logo + App Name
        // ------------------------------------------------------

        pw.Row(
          mainAxisAlignment:
          pw.MainAxisAlignment.center,
          children: [
            pw.Container(
              width: 54,
              height: 54,
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: PdfColors.white,
                border: pw.Border.all(
                  color: gold,
                  width: 1.2,
                ),
              ),
              child: pw.ClipOval(
                child: pw.Image(
                  logoImage,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
          ],
        ),

        pw.SizedBox(
          height: 7,
        ),

        pw.Text(
          'حصن المسلم',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: darkTeal,
          ),
        ),

        pw.SizedBox(
          height: 3,
        ),

        pw.Text(
          'قصص الأنبياء',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            fontSize: 9,
            color: secondaryText,
          ),
        ),

        pw.SizedBox(
          height: 16,
        ),

        // ------------------------------------------------------
        // Story Header Card
        // ------------------------------------------------------

        pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFF3F8F7),
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(
              color: PdfColor.fromInt(0xFFDCEBE8),
              width: 0.7,
            ),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                story.prophet,
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: darkTeal,
                ),
              ),

              pw.SizedBox(
                height: 5,
              ),

              pw.Text(
                'القصة ${currentIndex + 1} من $totalStories',
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 9,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(
          height: 12,
        ),

        // ------------------------------------------------------
        // Progress Line
        // ------------------------------------------------------

        pw.Container(
          height: 3,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFE5E7EB),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              width: 480 * progress,
              height: 3,
              decoration: pw.BoxDecoration(
                color: teal,
                borderRadius:
                pw.BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        pw.SizedBox(
          height: 8,
        ),

        // ------------------------------------------------------
        // Divider
        // ------------------------------------------------------

        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                height: 0.6,
                color: PdfColor.fromInt(
                  0xFFE5E7EB,
                ),
              ),
            ),

            pw.Container(
              width: 6,
              height: 6,
              margin: const pw.EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: const pw.BoxDecoration(
                color: gold,
                shape: pw.BoxShape.circle,
              ),
            ),

            pw.Expanded(
              child: pw.Container(
                height: 0.6,
                color: PdfColor.fromInt(
                  0xFFE5E7EB,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  static pw.Widget _buildFooter(
      pw.Context context,
      ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(
        top: 10,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColor.fromInt(
              0xFFE5E7EB,
            ),
            width: 0.7,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment:
        pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'حصن المسلم',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 8,
              color: secondaryText,
            ),
          ),

          pw.Text(
            'قصص الأنبياء',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 8,
              color: secondaryText,
            ),
          ),

          pw.Text(
            'صفحة ${context.pageNumber}',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 8,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // END OF STORY
  // ============================================================

  static pw.Widget _buildEndDivider() {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                height: 0.6,
                color: PdfColor.fromInt(
                  0xFFE5E7EB,
                ),
              ),
            ),

            pw.Container(
              width: 7,
              height: 7,
              margin: const pw.EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: const pw.BoxDecoration(
                color: gold,
                shape: pw.BoxShape.circle,
              ),
            ),

            pw.Expanded(
              child: pw.Container(
                height: 0.6,
                color: PdfColor.fromInt(
                  0xFFE5E7EB,
                ),
              ),
            ),
          ],
        ),

        pw.SizedBox(
          height: 10,
        ),

        pw.Text(
          'تمت القصة',
          textDirection: pw.TextDirection.rtl,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 9,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PREPARE STORY
  // ============================================================

  static List<String> _prepareParagraphs(
      String text,
      ) {
    return text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(
      RegExp(r'\n{2,}'),
      '\n',
    )
        .split('\n')
        .map(
          (paragraph) => paragraph.trim(),
    )
        .where(
          (paragraph) => paragraph.isNotEmpty,
    )
        .toList();
  }
}