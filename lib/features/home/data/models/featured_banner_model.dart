enum FeaturedBannerType {
  image,
  ayah,
  hadith,
  dhikr,
  dua,
}

class FeaturedBannerModel {
  final FeaturedBannerType type;

  final String title;
  final String subtitle;

  final String? content;
  final String? source;

  final String? image;
  final String? route;

  const FeaturedBannerModel({
    required this.type,
    required this.title,
    required this.subtitle,
    this.content,
    this.source,
    this.image,
    this.route,
  });

  bool get isImageBanner =>
      type == FeaturedBannerType.image;

  bool get isDailyContentBanner =>
      type != FeaturedBannerType.image;
}