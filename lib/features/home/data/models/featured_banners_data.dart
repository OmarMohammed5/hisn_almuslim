import 'package:hisn_almuslim/core/routing/app_routes.dart';

import 'featured_banner_model.dart';

const List<FeaturedBannerModel> featuredBanners = [
  FeaturedBannerModel(
    type: FeaturedBannerType.image,
    title: 'تتبع وردك اليومي',
    subtitle: 'تابع قراءتك من حيث توقفت',
    image: 'assets/images/banner_quran.jpg',
    route: AppRoutes.quranHome,
  ),



  FeaturedBannerModel(
    type: FeaturedBannerType.image,
    title: 'أذكار اليوم',
    subtitle: 'حصّن يومك بذكر الله',
    image: 'assets/images/banner_azkar.jpg',
    route: AppRoutes.hisnAlMuslim,
  ),

  FeaturedBannerModel(
    type: FeaturedBannerType.image,
    title: 'أحاديث نبوية',
    subtitle: 'تعرّف على أحاديث النبي ﷺ وتدبر معانيها',
    image: 'assets/images/banner_hadith.jpg',
    route: AppRoutes.hadith,
  ),

];