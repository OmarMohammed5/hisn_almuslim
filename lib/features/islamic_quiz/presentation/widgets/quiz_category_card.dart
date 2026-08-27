// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hisn_almuslim/core/shared/custom_text.dart';
// import 'package:hisn_almuslim/core/theme/app_colors.dart';
//
// import '../../domain/entities/main_category_entity.dart';
// import '../theme/quiz_tokens.dart';
// import 'quiz_press_scale.dart';
//
// class QuizCategoryCard extends StatelessWidget {
//   const QuizCategoryCard({
//     super.key,
//     required this.category,
//     required this.onTap,
//   });
//
//   final MainCategoryEntity category;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return QuizPressScale(
//       child: Material(
//         color: Colors.transparent,
//         child: GestureDetector(
//           onTap: onTap,
//           child: Ink(
//             padding: EdgeInsets.all(18.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(QuizRadius.lg.r),
//               color: QuizColors.card(context),
//               border: Border.all(color: QuizColors.border(context)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 45.w,
//                   height: 45.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(QuizRadius.md.r),
//                     color: QuizColors.primarySoft(context),
//                   ),
//                   alignment: Alignment.center,
//                   child: Icon(
//                     Icons.auto_stories_rounded,
//                     size: 20.sp,
//                     color: AppColors.kPrimary,
//                   ),
//                 ),
//                 SizedBox(width: QuizSpacing.md.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     spacing: 10.h,
//                     children: [
//                       CustomText(
//                         category.arabicName,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14.sp,
//                       ),
//                       CustomText(
//                         '${category.topics.length} موضوع',
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 27.w,
//                   height: 27.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: QuizColors.primarySoft(context),
//                   ),
//                   alignment: Alignment.center,
//                   child: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 14.sp,
//                     color: AppColors.kPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/main_category_entity.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_press_scale.dart';

class QuizCategoryCard extends StatelessWidget {
  const QuizCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final MainCategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QuizPressScale(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          QuizRadius.lg.r,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            QuizRadius.lg.r,
          ),
          child: Ink(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                QuizRadius.lg.r,
              ),
              color: QuizColors.card(context),
              border: Border.all(
                color: QuizColors.border(context),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      QuizRadius.md.r,
                    ),
                    color: QuizColors.primarySoft(
                      context,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 20.sp,
                    color: AppColors.kPrimary,
                  ),
                ),

                SizedBox(
                  width: QuizSpacing.md.w,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    spacing: 10.h,
                    children: [
                      CustomText(
                        category.arabicName,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),

                      CustomText(
                        '${category.topics.length} موضوع',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 27.w,
                  height: 27.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: QuizColors.primarySoft(
                      context,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}