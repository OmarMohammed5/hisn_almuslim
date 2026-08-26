import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../data/datasource/daily_content_local_data_source.dart';
import '../data/models/daily_content_model.dart';
import '../data/models/featured_banner_model.dart';
import '../data/models/featured_banners_data.dart';
import 'daily_content_banner.dart';
import 'featured_banner_card.dart';

class FeaturedBanners extends StatefulWidget {
  const FeaturedBanners({super.key});

  @override
  State<FeaturedBanners> createState() => _FeaturedBannersState();
}

class _FeaturedBannersState extends State<FeaturedBanners> {
  final DailyContentLocalDataSource _dataSource = DailyContentLocalDataSource();

  int _currentIndex = 0;

  bool _isLoading = true;

  List<FeaturedBannerModel> _banners = [];

  @override
  void initState() {
    super.initState();

    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final content = await _dataSource.loadContent();

      final banners = _buildDailyBanners(content);

      if (!mounted) return;

      setState(() {
        _banners = [...featuredBanners, ...banners];

        _isLoading = false;
      });
    } catch (e, stackTrace) {
      if (!mounted) return;

      setState(() {
        _banners = featuredBanners;
        _isLoading = false;
      });
    }
  }

  List<FeaturedBannerModel> _buildDailyBanners(
    Map<String, List<DailyContentModel>> content,
  ) {
    final now = DateTime.now();

    return [
      _createDailyBanner(
        type: FeaturedBannerType.ayah,
        title: 'آية اليوم',
        subtitle: 'تدبر آية من كتاب الله',
        items: content['ayah'] ?? [],
        date: now,
      ),

      _createDailyBanner(
        type: FeaturedBannerType.hadith,
        title: 'حديث اليوم',
        subtitle: 'من هدي النبي ﷺ',
        items: content['hadith'] ?? [],
        date: now,
      ),

      _createDailyBanner(
        type: FeaturedBannerType.dhikr,
        title: 'ذكر اليوم',
        subtitle: 'اذكر الله واطمئن',
        items: content['dhikr'] ?? [],
        date: now,
      ),

      _createDailyBanner(
        type: FeaturedBannerType.dua,
        title: 'دعاء اليوم',
        subtitle: 'ادعُ الله بما تحب',
        items: content['dua'] ?? [],
        date: now,
      ),
    ];
  }

  FeaturedBannerModel _createDailyBanner({
    required FeaturedBannerType type,
    required String title,
    required String subtitle,
    required List<DailyContentModel> items,
    required DateTime date,
  }) {
    if (items.isEmpty) {
      return FeaturedBannerModel(
        type: type,
        title: title,
        subtitle: subtitle,
        content: '',
        source: '',
      );
    }

    final index = _getDailyIndex(length: items.length, date: date, type: type);

    final item = items[index];

    return FeaturedBannerModel(
      type: type,
      title: title,
      subtitle: subtitle,
      content: item.content,
      source: item.source,
    );
  }

  int _getDailyIndex({
    required int length,
    required DateTime date,
    required FeaturedBannerType type,
  }) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;

    final offset = switch (type) {
      FeaturedBannerType.ayah => 0,
      FeaturedBannerType.hadith => 2,
      FeaturedBannerType.dhikr => 4,
      FeaturedBannerType.dua => 6,
      FeaturedBannerType.image => 0,
    };

    return (dayOfYear + offset) % length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 140.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // ======================================================
        // Carousel
        // ======================================================
        CarouselSlider.builder(
          itemCount: _banners.length,

          itemBuilder: (context, index, realIndex) {
            final banner = _banners[index];

            // -----------------------------------------------
            // Daily Content Banner
            // -----------------------------------------------

            if (banner.isDailyContentBanner) {
              return DailyContentBanner(banner: banner);
            }

            // -----------------------------------------------
            // Image Banner
            // -----------------------------------------------

            return FeaturedBannerCard(
              banner: banner,
              onTap: () {
                if (banner.route == null) {
                  return;
                }

                Navigator.pushNamed(context, banner.route!);
              },
            );
          },

          options: CarouselOptions(
            height: 140.h,

            viewportFraction: 0.9,

            enlargeCenterPage: false,

            autoPlay: true,

            autoPlayInterval: const Duration(seconds: 5),

            autoPlayAnimationDuration: const Duration(milliseconds: 700),

            autoPlayCurve: Curves.easeInOut,

            enableInfiniteScroll: true,

            pauseAutoPlayOnTouch: true,

            onPageChanged: (index, reason) {
              if (!mounted) return;

              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        // Indicator
        Gap(18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isActive = index == _currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              margin: EdgeInsets.symmetric(horizontal: 3.w),

              width: isActive ? 22.w : 6.w,

              height: 5.w,

              decoration: BoxDecoration(
                color: isActive
                    ? Colors.teal.shade300
                    : Colors.grey.shade800.withValues(alpha: 0.6),

                borderRadius: BorderRadius.circular(10.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}
