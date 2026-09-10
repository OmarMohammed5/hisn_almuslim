import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class QuranTafsirPage extends StatelessWidget {
  final int ayahNumber;
  final String ayahText;
  final String tafsirText;
  final String tafsirSource;

  const QuranTafsirPage({
    super.key,
    required this.ayahNumber,
    required this.ayahText,
    required this.tafsirText,
    required this.tafsirSource,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفسير الآية $ayahNumber',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppResponsive.fontSize(context, 18),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Share tafsir
            },
            icon: Icon(Icons.share, size: AppResponsive.fontSize(context, 22)),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppResponsive.isDesktop(context)
                ? 1000.0
                : AppResponsive.isTablet(context)
                    ? 820.0
                    : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayah Card
            Center(
              child: Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [Colors.grey[800]!, Colors.grey[900]!]
                        : [Colors.green[50]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.green[200]!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Ayah number
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 12), vertical: AppResponsive.heightValue(context, 4)),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.green[200],
                        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
                      ),
                      child: Text(
                        '﴿ $ayahNumber ﴾',
                        style: TextStyle(
                          fontFamily: 'Al mushaf',
                          fontSize: AppResponsive.fontSize(context, 16),
                          color: isDark ? Colors.white : Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(height: AppResponsive.heightValue(context, 12)),

                    // Ayah text
                    Text(
                      ayahText,
                      style: TextStyle(
                        fontFamily: 'Al mushaf',
                        fontSize: AppResponsive.fontSize(context, 24),
                        height: 1.8,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppResponsive.heightValue(context, 24)),

            // Tafsir Source
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
                  ),
                  child: Icon(
                    Icons.book,
                    size: AppResponsive.fontSize(context, 20),
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(width: AppResponsive.widthValue(context, 12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppResponsive.heightValue(context, 5),
                  children: [
                    CustomText(
                      'المصدر',
                        fontSize: AppResponsive.fontSize(context, 10),
                        color: Colors.grey[600],
                    ),
                    CustomText(
                      tafsirSource,
                        fontSize: AppResponsive.fontSize(context, 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: AppResponsive.heightValue(context, 16)),

            // Divider
            Divider(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              height: 1,
              thickness: 1,
            ),

            SizedBox(height: AppResponsive.heightValue(context, 16)),

            // Tafsir Title
            CustomText(
              'التفسير',
                fontSize: AppResponsive.fontSize(context, 15),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
            ),
            SizedBox(height: AppResponsive.heightValue(context, 12)),


            // Tafsir Text
            Text(
              tafsirText,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 16),
                fontFamily: "Uthmani",
                height: 1.8,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: AppResponsive.heightValue(context, 24)),

            ],
          ),
        ),
      ),
    ));
  }
}