import 'package:flutter/material.dart';
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
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Share tafsir
            },
            icon: Icon(Icons.share, size: 22.sp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayah Card
            Center(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [Colors.grey[800]!, Colors.grey[900]!]
                        : [Colors.green[50]!, Colors.green[100]!],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
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
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.green[200],
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        '﴿ $ayahNumber ﴾',
                        style: TextStyle(
                          fontFamily: 'Al mushaf',
                          fontSize: 16.sp,
                          color: isDark ? Colors.white : Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Ayah text
                    Text(
                      ayahText,
                      style: TextStyle(
                        fontFamily: 'Al mushaf',
                        fontSize: 24.sp,
                        height: 1.8,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Tafsir Source
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.book,
                    size: 20.sp,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.h,
                  children: [
                    CustomText(
                      'المصدر',
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                    ),
                    CustomText(
                      tafsirSource,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Divider
            Divider(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              height: 1,
              thickness: 1,
            ),

            SizedBox(height: 16.h),

            // Tafsir Title
            CustomText(
              'التفسير',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
            ),
            SizedBox(height: 12.h),
//////// Can you tell me where is the content of tafsir //////
          ///
          /// ??
          /// ??


            // Tafsir Text
            Text(
              tafsirText,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Uthmani",
                height: 1.8,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: 24.h),

            // // Footer
            // Center(
            //   child: Column(
            //     spacing: 8.h,
            //     children: [
            //       Text(
            //         'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِن مُّدَّكِرٍ',
            //         style: TextStyle(
            //           fontFamily: 'Al mushaf',
            //           fontSize: 13.sp,
            //           color: isDark ? Colors.grey[900] : Colors.grey[900],
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            //         decoration: BoxDecoration(
            //           color: isDark ? Colors.grey[800] : Colors.green[50],
            //           borderRadius: BorderRadius.circular(12.r),
            //         ),
            //         child: Text(
            //           'صدق الله العظيم',
            //           style: TextStyle(
            //             fontFamily: 'Al mushaf',
            //             fontSize: 20.sp,
            //             color: Colors.green[700],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}