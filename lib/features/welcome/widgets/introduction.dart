import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/welcome/widgets/page_view.dart';
import 'package:hisn_almuslim/root.dart';
import 'package:hisn_almuslim/shared/app_logo.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => Root()));
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.transparent,
      controlsMargin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      controlsPadding: EdgeInsets.only(bottom: 20.h),
      pages: [
        // Page 1 >> Welcome
        pageView(
          title: "مرحباً بك في حصن المسلم",
          desc: "رفيقك الروحي اليومي — أذكار، قرآن، أحاديث، وأكثر في مكان واحد",
          icon: const AppLogo(),
          featureBadges: const [],
          accentColor: const Color(0xFFD4AF37),
        ),

        // Page 2 >> Quran
        pageView(
          title: "القرآن الكريم",
          desc:
              "اقرأ المصحف الشريف بتجربة قراءة أنيقة ومريحة للعين، في أي وقت وأي مكان",
          icon: Icon(
            FlutterIslamicIcons.quran2,
            size: 110.w,
            color: Colors.white,
          ),
          featureBadges: const ["قراءة سهلة", "بحث سريع", "تصفح بالسور"],
          accentColor: const Color(0xFF4CAF82),
        ),

        // Page 3 >> Hadiths
        pageView(
          title: "الأحاديث النبوية الشريفة",
          desc: "تصفّح أحاديث صحيح البخاري ومسلم وغيرها من كتب السنة المصنّفة",
          icon: Icon(
            FlutterIslamicIcons.mohammad,
            size: 110.w,
            color: Colors.white,
          ),
          featureBadges: const [
            "البخاري",
            "مسلم",
            "رياض الصالحين",
            "الأربعون النووية",
          ],
          accentColor: const Color(0xFF8B6914),
        ),

        // Page 4 >> Azkar & Duas
        pageView(
          title: "الأذكار والأدعية المأثورة",
          desc:
              "أذكار الصباح والمساء، أدعية الأحوال، وعداد التسبيح — كل ما تحتاجه لتزكية روحك",
          icon: Icon(
            CupertinoIcons.search,
            size: 110.w,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),

          featureBadges: const ["عداد تسبيح", "أذكار الصباح", "أذكار المساء"],
          accentColor: const Color(0xFF4A90D9),
        ),

        // Page 5 >> Asma Allah
        pageView(
          title: "أسماء الله الحسنى",
          desc:
              "تأمّل في أسماء الله التسع والتسعين مع شرح معنى كل اسم وفضل ذكره",
          icon: Icon(
            FlutterIslamicIcons.allah,
            size: 110.w,
            color: Colors.white,
          ),
          featureBadges: const ["٩٩ اسمًا", "شرح المعاني", "التفضّل بالذكر"],
          accentColor: const Color(0xFFB07FDB),
        ),

        // Page 6 >> Adhan
        pageView(
          title: "مواقيت الصلاة والتنبيهات",
          desc:
              "استقبل تنبيهات أذكار الصباح والمساء , ورد القرآن اليومي في أوقاتها تلقائيًا",
          icon: Icon(
            Icons.notifications_active_outlined,
            size: 110.w,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),

          featureBadges: const [
            "أوقات الصلاة",
            "ورد يومي",
            "أذكار الصباح والمساء",
          ],
          accentColor: const Color(0xFFE07B54),
          isLast: true,
        ),
      ],

      showSkipButton: true,
      showBackButton: true,

      skip: _navButton("تخطي", isSkip: true),
      next: _navButton("التالي"),
      back: _navButton("السابق"),
      done: _doneButton(),

      onDone: () => _completeOnboarding(context),

      dotsDecorator: DotsDecorator(
        size: Size(6.w, 6.h),
        activeSize: Size(18.w, 6.h),
        color: Colors.white.withValues(alpha: 0.25),
        activeColor: const Color(0xFFD4AF37),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _navButton(String txt, {bool isSkip = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: isSkip
          ? null
          : BoxDecoration(
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
      child: CustomText(
        txt,
        fontWeight: FontWeight.bold,
        fontSize: 11.sp,
        color: isSkip
            ? Colors.white.withValues(alpha: 0.6)
            : const Color(0xFFD4AF37),
      ),
    );
  }

  Widget _doneButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomText(
        "ابدأ الآن",
        fontWeight: FontWeight.bold,
        fontSize: 12.sp,
        color: const Color(0xFF0D1B2A),
      ),
    );
  }
}
