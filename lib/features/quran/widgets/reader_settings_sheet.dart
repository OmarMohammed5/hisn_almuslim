import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/widgets/reader_settings.dart';
import '../../../core/shared/custom_text.dart';

class QuranReadingModeInfo {
  final QuranReadingMode mode;
  final String title;
  final String subtitle;
  final IconData icon;

  const QuranReadingModeInfo({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

final List<QuranReadingModeInfo> quranReadingModes = [
  QuranReadingModeInfo(
    mode: QuranReadingMode.continuous,
    title: 'القراءة المتصلة',
    subtitle: 'تدفّق مريح للقراءة الطويلة',
    icon: Icons.menu_book_rounded,
  ),
  const QuranReadingModeInfo(
    mode: QuranReadingMode.focus,
    title: 'التركيز على الآية',
    subtitle: 'كل آية في مساحتها الخاصة',
    icon: Icons.center_focus_strong_rounded,
  ),
  const QuranReadingModeInfo(
    mode: QuranReadingMode.page,
    title: 'صفحة المصحف',
    subtitle: 'تجربة أقرب إلى المصحف الورقي',
    icon: Icons.auto_stories_rounded,
  ),

  const QuranReadingModeInfo(
    mode: QuranReadingMode.qari,
    title: 'القراءة الغامرة',
    subtitle: 'القراءة المتتاليه للأيات',
    icon: Icons.filter_list,
  ),
];

class ReaderSettingsSheet extends StatefulWidget {
  final QuranReaderSettings settings;

  final ValueChanged<QuranReaderSettings> onChanged;

  final VoidCallback onChooseMode;
  final VoidCallback onClose;

  const ReaderSettingsSheet({
    super.key,
    required this.settings,
    required this.onChanged,
    required this.onChooseMode,
    required this.onClose,
  });

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  late QuranReaderSettings _localSettings;

  @override
  void initState() {
    super.initState();

    _localSettings = widget.settings;
  }

  @override
  void didUpdateWidget(covariant ReaderSettingsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.settings != widget.settings) {
      _localSettings = widget.settings;
    }
  }

  void _updateSettings(QuranReaderSettings value) {
    if (_localSettings == value) {
      return;
    }

    setState(() {
      _localSettings = value;
    });

    widget.onChanged(value);
  }

  Color _background() {
    return _localSettings.darkMode
        ? const Color(0xFF101815)
        : const Color(0xFFF7F4EC);
  }

  Color _surface() {
    return _localSettings.darkMode
        ? const Color(0xFF171F1B)
        : const Color(0xFFFDFBF5);
  }

  Color _text() {
    return _localSettings.darkMode
        ? const Color(0xFFECE6D6)
        : const Color(0xFF20281F);
  }

  Color _muted() {
    return _localSettings.darkMode
        ? const Color(0xFF8E9A92)
        : const Color(0xFF7B837C);
  }

  Color _primary() {
    return _localSettings.darkMode
        ? const Color(0xFF7EB6A8)
        : const Color(0xFF1F5145);
  }

  Color _gold() {
    return _localSettings.darkMode
        ? const Color(0xFFD2B57C)
        : const Color(0xFFAC8E54);
  }

  @override
  Widget build(BuildContext context) {
    final background = _background();
    final surface = _surface();
    final text = _text();
    final muted = _muted();
    final primary = _primary();
    final gold = _gold();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,

      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),

          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppResponsive.radius(context, 28)),
            ),
          ),

          child: Column(
            children: [
              SizedBox(height: AppResponsive.heightValue(context, 10)),

              Container(
                width: AppResponsive.widthValue(context, 38),
                height: AppResponsive.heightValue(context, 4),
                decoration: BoxDecoration(
                  color: muted.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 20),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.widthValue(context, 18),
                  AppResponsive.heightValue(context, 12),
                  AppResponsive.widthValue(context, 18),
                  AppResponsive.heightValue(context, 8),
                ),

                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onClose,

                      icon: Icon(Icons.close_rounded, color: muted),
                    ),

                    Expanded(
                      child: CustomText(
                        'إعدادات القراءة',
                        textAlign: TextAlign.center,
                        color: text,
                        fontSize: AppResponsive.fontSize(context, 13),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: AppResponsive.widthValue(context, 48)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 18),
                    AppResponsive.heightValue(context, 4),
                    AppResponsive.widthValue(context, 18),
                    AppResponsive.heightValue(context, 30),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      _sectionTitle(context, 'نمط القراءة', muted),

                      _settingCard(
                        context: context,
                        color: surface,
                        child: _modeRow(
                          context,
                          text: text,
                          muted: muted,
                          primary: primary,
                          gold: gold,
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 20)),

                      _sectionTitle(context, 'حجم الخط', muted),

                      _settingCard(
                        context: context,
                        color: surface,

                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.widthValue(context, 16),
                            vertical: AppResponsive.heightValue(context, 14),
                          ),

                          child: Row(
                            children: [
                              CustomText(
                                _fontLabel(_localSettings.fontSize),
                                color: text,
                                fontSize: AppResponsive.fontSize(context, 12),
                                fontWeight: FontWeight.w600,
                              ),

                              const Spacer(),

                              _fontButton(
                                context,
                                icon: Icons.remove_rounded,
                                enabled: _localSettings.fontSize > 17,
                                onTap: () {
                                  final value = (_localSettings.fontSize - 2)
                                      .clamp(17, 27)
                                      .toDouble();
                                  _updateSettings(
                                    _localSettings.copyWith(fontSize: value),
                                  );
                                },
                              ),

                              SizedBox(
                                width: AppResponsive.widthValue(context, 8),
                              ),
                              Container(
                                width: AppResponsive.widthValue(context, 46),
                                alignment: Alignment.center,
                                child: CustomText(
                                  'A',
                                  color: primary,
                                  fontSize: AppResponsive.fontSize(context, 13),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(
                                width: AppResponsive.widthValue(context, 8),
                              ),

                              _fontButton(
                                context,

                                icon: Icons.add_rounded,

                                enabled: _localSettings.fontSize < 27,

                                onTap: () {
                                  final value = (_localSettings.fontSize + 2)
                                      .clamp(17, 27)
                                      .toDouble();

                                  _updateSettings(
                                    _localSettings.copyWith(fontSize: value),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 20)),

                      // =========================================
                      // THEME
                      // =========================================
                      _sectionTitle(context, 'المظهر', muted),

                      _settingCard(
                        context: context,
                        color: surface,

                        child: Padding(
                          padding: EdgeInsets.all(
                            AppResponsive.widthValue(context, 12),
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: _themeOption(
                                  context,

                                  title: 'فاتح',

                                  icon: Icons.light_mode_outlined,

                                  selected: !_localSettings.darkMode,

                                  primary: primary,

                                  text: text,

                                  onTap: () {
                                    _updateSettings(
                                      _localSettings.copyWith(darkMode: false),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(
                                width: AppResponsive.widthValue(context, 10),
                              ),

                              Expanded(
                                child: _themeOption(
                                  context,

                                  title: 'داكن',

                                  icon: Icons.dark_mode_outlined,

                                  selected: _localSettings.darkMode,

                                  primary: primary,

                                  text: text,

                                  onTap: () {
                                    _updateSettings(
                                      _localSettings.copyWith(darkMode: true),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 22)),

                      // =========================================
                      // READING EXPERIENCE
                      // =========================================
                      _sectionTitle(context, 'تجربة القراءة', muted),

                      _settingCard(
                        context: context,
                        color: surface,

                        child: Column(
                          children: [
                            _simpleInfoRow(
                              context: context,
                              text: text,
                              muted: muted,
                              icon: Icons.touch_app_outlined,
                              title: 'التفاعل مع الآيات',
                              subtitle: 'اضغط على الآية لفتح الإجراءات',
                            ),

                            _divider(context, muted),

                            _simpleInfoRow(
                              context: context,
                              text: text,
                              muted: muted,
                              icon: Icons.bookmark_border_rounded,
                              title: 'التظليل',
                              subtitle: 'احفظ الآيات المهمة للرجوع إليها',
                            ),

                            _divider(context, muted),

                            _simpleInfoRow(
                              context: context,
                              text: text,
                              muted: muted,
                              icon: Icons.volume_up_outlined,
                              title: 'الاستماع',
                              subtitle: 'تشغيل الآيات بالتتابع',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 20)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // MODE ROW
  // ===============================================================

  Widget _modeRow(
    BuildContext context, {
    required Color text,
    required Color muted,
    required Color primary,
    required Color gold,
  }) {
    final current = quranReadingModes.firstWhere(
      (item) => item.mode == _localSettings.mode,

      orElse: () => quranReadingModes.first,
    );

    return InkWell(
      onTap: widget.onChooseMode,

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 16),
          vertical: AppResponsive.heightValue(context, 14),
        ),

        child: Row(
          children: [
            Container(
              width: AppResponsive.widthValue(context, 42),
              height: AppResponsive.widthValue(context, 42),

              decoration: BoxDecoration(
                color: primary.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 13),
                ),
              ),

              child: Icon(
                current.icon,
                color: primary,
                size: AppResponsive.fontSize(context, 21),
              ),
            ),

            SizedBox(width: AppResponsive.widthValue(context, 12)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    current.title,
                    color: text,
                    fontSize: AppResponsive.fontSize(context, 13),
                    fontWeight: FontWeight.w700,
                  ),

                  SizedBox(height: AppResponsive.heightValue(context, 6)),

                  CustomText(
                    current.subtitle,
                    color: muted,
                    fontSize: AppResponsive.fontSize(context, 11),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_sharp,
              size: AppResponsive.fontSize(context, 15),
              color: muted,
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _sectionTitle(BuildContext context, String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(
        right: AppResponsive.widthValue(context, 3),
        bottom: AppResponsive.heightValue(context, 8),
      ),
      child: CustomText(
        title,
        color: color,
        fontSize: AppResponsive.fontSize(context, 11),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ===============================================================
  // SETTING CARD
  // ===============================================================

  Widget _settingCard({
    required BuildContext context,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,

        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
      ),

      child: child,
    );
  }

  // FONT BUTTON

  Widget _fontButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final dark = _localSettings.darkMode;

    return Material(
      color: dark ? const Color(0xFF202A25) : const Color(0xFFF0EBDC),
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 11)),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 11)),
        child: SizedBox(
          width: AppResponsive.widthValue(context, 38),
          height: AppResponsive.widthValue(context, 36),
          child: Icon(
            icon,
            size: AppResponsive.fontSize(context, 17),
            color: enabled
                ? (dark ? const Color(0xFF7EB6A8) : const Color(0xFF1F5145))
                : Colors.grey.withValues(alpha: .3),
          ),
        ),
      ),
    );
  }

  // THEME OPTION

  Widget _themeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool selected,
    required Color primary,
    required Color text,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? primary.withValues(alpha: .08) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
        border: Border.all(
          color: selected ? primary.withValues(alpha: .45) : Colors.transparent,
        ),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.heightValue(context, 12),
            horizontal: AppResponsive.widthValue(context, 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppResponsive.fontSize(context, 17),
                color: selected ? primary : text.withValues(alpha: .55),
              ),

              SizedBox(width: AppResponsive.widthValue(context, 7)),

              CustomText(
                title,
                color: selected ? primary : text,
                fontSize: AppResponsive.fontSize(context, 11),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // INFO ROW

  Widget _simpleInfoRow({
    required BuildContext context,
    required Color text,
    required Color muted,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 15),
        vertical: AppResponsive.heightValue(context, 13),
      ),

      child: Row(
        children: [
          Icon(icon, color: muted, size: AppResponsive.fontSize(context, 20)),

          SizedBox(width: AppResponsive.widthValue(context, 14)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                CustomText(
                  title,
                  color: text,
                  fontSize: AppResponsive.fontSize(context, 10),
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: AppResponsive.heightValue(context, 12)),

                CustomText(
                  subtitle,
                  color: muted,
                  fontSize: AppResponsive.fontSize(context, 9.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // DIVIDER
  // ===============================================================

  Widget _divider(BuildContext context, Color color) {
    return Divider(
      height: 1,
      thickness: .5,
      indent: AppResponsive.widthValue(context, 48),

      color: color.withValues(alpha: .10),
    );
  }

  // ===============================================================
  // FONT LABEL
  // ===============================================================

  String _fontLabel(double value) {
    if (value <= 17) {
      return 'صغير';
    }

    if (value <= 21) {
      return 'متوسط';
    }

    if (value <= 25) {
      return 'كبير';
    }

    return 'كبير جدًا';
  }
}
