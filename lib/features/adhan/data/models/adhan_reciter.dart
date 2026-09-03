class AdhanReciter {
  final String id;
  final String name;
  final String assetPath;
  final String rawSound;

  const AdhanReciter({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.rawSound,
  });



  static const refaat = AdhanReciter(
    id: 'refaat',
    name: 'محمد رفعت',
    assetPath: 'audio/adhan/adhan_refaat.mp3',
    rawSound: 'adhan_refaat',
  );


  static const banna = AdhanReciter(
    id: 'banna',
    name: 'محمود علي البنا',
    assetPath: 'audio/adhan/adhan_banna.mp3',
    rawSound: 'adhan_banna',
  );

  static const mishary = AdhanReciter(
    id: 'mishary',
    name: 'مشاري راشد العفاسي',
    assetPath: 'audio/adhan/adhan_mishary.mp3',
    rawSound: 'adhan_mishary',
  );

  static const zahrani = AdhanReciter(
    id: 'zahrani',
    name: 'منصور الزهراني',
    assetPath: 'audio/adhan/adhan_zahrani.mp3',
    rawSound: 'adhan_zahrani',
  );

  static const List<AdhanReciter> all = [
    mishary,
    banna,
    refaat,
    zahrani,
  ];

  static AdhanReciter fromId(String id) {
    return all.firstWhere(
          (reciter) => reciter.id == id,
      orElse: () => mishary,
    );
  }
}