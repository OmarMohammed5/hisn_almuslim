import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

enum QuranReadingMode { continuous, focus, page, qari, tajweed }

class QuranReaderSettings {
  final QuranReadingMode mode;
  final double fontSize;
  final bool darkMode;

  const QuranReaderSettings({
    this.mode = QuranReadingMode.continuous,
    this.fontSize = 16,
    this.darkMode = false,
  });

  QuranReaderSettings copyWith({
    QuranReadingMode? mode,
    double? fontSize,
    bool? darkMode,
  }) {
    return QuranReaderSettings(
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuranReaderSettings &&
        other.mode == mode &&
        other.fontSize == fontSize &&
        other.darkMode == darkMode;
  }

  @override
  int get hashCode {
    return Object.hash(mode, fontSize, darkMode);
  }
}

/// ===============================================================
/// MODE INFO
/// ===============================================================

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

const List<QuranReadingModeInfo> quranReadingModes = [
  QuranReadingModeInfo(
    mode: QuranReadingMode.continuous,
    title: 'القراءة المتصلة',
    subtitle: 'تدفّق مريح للقراءة الطويلة',
    icon: Icons.menu_book_rounded,
  ),
  QuranReadingModeInfo(
    mode: QuranReadingMode.focus,
    title: 'التركيز على الآية',
    subtitle: 'كل آية في مساحتها الخاصة',
    icon: Icons.center_focus_strong_rounded,
  ),
  QuranReadingModeInfo(
    mode: QuranReadingMode.page,
    title: 'صفحة المصحف',
    subtitle: 'تجربة أقرب إلى المصحف الورقي',
    icon: Icons.auto_stories_rounded,
  ),
];

/// ===============================================================
/// READER SETTINGS SHEET
/// ===============================================================

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

        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),

          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),

          child: Column(
            children: [
              SizedBox(height: 10.h),

              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: muted.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),

              // =================================================
              // HEADER
              // =================================================
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 8.h),

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

                        fontSize: 16.sp,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(width: 48.w),
                  ],
                ),
              ),

              // =================================================
              // CONTENT
              // =================================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 30.h),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      // =========================================
                      // MODE
                      // =========================================
                      _sectionTitle('نمط القراءة', muted),

                      _settingCard(
                        surface,

                        child: _modeRow(
                          context,

                          text: text,
                          muted: muted,
                          primary: primary,
                          gold: gold,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // =========================================
                      // FONT SIZE
                      // =========================================
                      _sectionTitle('حجم الخط', muted),

                      _settingCard(
                        surface,

                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),

                          child: Row(
                            children: [
                              Text(
                                _fontLabel(_localSettings.fontSize),

                                style: TextStyle(
                                  color: text,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
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

                              SizedBox(width: 8.w),

                              Container(
                                width: 46.w,

                                alignment: Alignment.center,

                                child: Text(
                                  'A',

                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              SizedBox(width: 8.w),

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

                      SizedBox(height: 20.h),

                      // =========================================
                      // THEME
                      // =========================================
                      _sectionTitle('المظهر', muted),

                      _settingCard(
                        surface,

                        child: Padding(
                          padding: EdgeInsets.all(12.w),

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

                              SizedBox(width: 10.w),

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

                      SizedBox(height: 20.h),

                      // =========================================
                      // READING EXPERIENCE
                      // =========================================
                      _sectionTitle('تجربة القراءة', muted),

                      _settingCard(
                        surface,

                        child: Column(
                          children: [
                            _simpleInfoRow(
                              text: text,
                              muted: muted,
                              icon: Icons.touch_app_outlined,
                              title: 'التفاعل مع الآيات',
                              subtitle: 'اضغط على الآية لفتح الإجراءات',
                            ),

                            _divider(muted),

                            _simpleInfoRow(
                              text: text,
                              muted: muted,
                              icon: Icons.bookmark_border_rounded,
                              title: 'التظليل',
                              subtitle: 'احفظ الآيات المهمة للرجوع إليها',
                            ),

                            _divider(muted),

                            _simpleInfoRow(
                              text: text,
                              muted: muted,
                              icon: Icons.volume_up_outlined,
                              title: 'الاستماع',
                              subtitle: 'تشغيل الآيات بالتتابع',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // =========================================
                      // INFO
                      // =========================================
                      _settingCard(
                        surface,

                        child: Padding(
                          padding: EdgeInsets.all(15.w),

                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,

                                decoration: BoxDecoration(
                                  color: gold.withValues(alpha: .10),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),

                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  color: gold,
                                  size: 20.sp,
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: CustomText(
                                  'يمكنك تغيير نمط القراءة في أي وقت، وسيتم تطبيق التغيير مباشرة وحفظ اختيارك تلقائيًا.',

                                  color: muted,

                                  fontSize: 11.sp,

                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),

        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,

              decoration: BoxDecoration(
                color: primary.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(13.r),
              ),

              child: Icon(current.icon, color: primary, size: 21.sp),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CustomText(
                    current.title,

                    color: text,

                    fontSize: 13.sp,

                    fontWeight: FontWeight.w700,
                  ),

                  SizedBox(height: 6.h),

                  CustomText(current.subtitle, color: muted, fontSize: 11.sp),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_sharp, size: 15.sp, color: muted),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w, bottom: 8.h),

      child: CustomText(
        title,

        color: color,

        fontSize: 11.sp,

        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ===============================================================
  // SETTING CARD
  // ===============================================================

  Widget _settingCard(Color color, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: color,

        borderRadius: BorderRadius.circular(18.r),
      ),

      child: child,
    );
  }

  // ===============================================================
  // FONT BUTTON
  // ===============================================================

  Widget _fontButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final dark = _localSettings.darkMode;

    return Material(
      color: dark ? const Color(0xFF202A25) : const Color(0xFFF0EBDC),

      borderRadius: BorderRadius.circular(11.r),

      child: InkWell(
        onTap: enabled ? onTap : null,

        borderRadius: BorderRadius.circular(11.r),

        child: SizedBox(
          width: 38.w,
          height: 36.w,

          child: Icon(
            icon,

            size: 18.sp,

            color: enabled
                ? (dark ? const Color(0xFF7EB6A8) : const Color(0xFF1F5145))
                : Colors.grey.withValues(alpha: .3),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // THEME OPTION
  // ===============================================================

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

        borderRadius: BorderRadius.circular(14.r),

        border: Border.all(
          color: selected ? primary.withValues(alpha: .45) : Colors.transparent,
        ),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(14.r),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(
                icon,

                size: 17.sp,

                color: selected ? primary : text.withValues(alpha: .55),
              ),

              SizedBox(width: 7.w),

              Text(
                title,

                style: TextStyle(
                  color: selected ? primary : text,

                  fontSize: 12.sp,

                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // INFO ROW
  // ===============================================================

  Widget _simpleInfoRow({
    required Color text,
    required Color muted,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),

      child: Row(
        children: [
          Icon(icon, color: muted, size: 20.sp),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: text,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  subtitle,

                  style: TextStyle(color: muted, fontSize: 9.5.sp),
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

  Widget _divider(Color color) {
    return Divider(
      height: 1,
      thickness: .5,
      indent: 48.w,

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

/// ===============================================================
/// READING MODE SHEET
/// ===============================================================

class ReadingModeSheet extends StatelessWidget {
  final QuranReadingMode selected;
  final bool darkMode;

  final ValueChanged<QuranReadingMode> onSelected;

  const ReadingModeSheet({
    super.key,
    required this.selected,
    required this.darkMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bg = darkMode ? const Color(0xFF101815) : const Color(0xFFF7F4EC);

    final surface = darkMode
        ? const Color(0xFF171F1B)
        : const Color(0xFFFDFBF5);

    final text = darkMode ? const Color(0xFFECE6D6) : const Color(0xFF20281F);

    final muted = darkMode ? const Color(0xFF8E9A92) : const Color(0xFF7B837C);

    final primary = darkMode
        ? const Color(0xFF7EB6A8)
        : const Color(0xFF1F5145);

    final gold = darkMode ? const Color(0xFFD2B57C) : const Color(0xFFAC8E54);

    return SafeArea(
      top: false,

      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .75,
        ),

        decoration: BoxDecoration(
          color: bg,

          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),

        child: Column(
          children: [
            SizedBox(height: 10.h),

            Container(
              width: 38.w,
              height: 4.h,

              decoration: BoxDecoration(
                color: muted.withValues(alpha: .25),

                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),

              child: Text(
                'اختر نمط القراءة',

                style: TextStyle(
                  color: text,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 25.h),

                physics: const BouncingScrollPhysics(),

                itemCount: quranReadingModes.length,

                separatorBuilder: (_, __) => SizedBox(height: 8.h),

                itemBuilder: (context, index) {
                  final item = quranReadingModes[index];

                  final isSelected = item.mode == selected;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary.withValues(alpha: .08)
                          : surface,

                      borderRadius: BorderRadius.circular(17.r),

                      border: Border.all(
                        color: isSelected
                            ? primary.withValues(alpha: .55)
                            : Colors.transparent,
                      ),
                    ),

                    child: InkWell(
                      onTap: () {
                        onSelected(item.mode);

                        Navigator.pop(context);
                      },

                      borderRadius: BorderRadius.circular(17.r),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 13.h,
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 43.w,
                              height: 43.w,

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withValues(alpha: .10)
                                    : muted.withValues(alpha: .07),

                                borderRadius: BorderRadius.circular(13.r),
                              ),

                              child: Icon(
                                item.icon,

                                color: isSelected ? primary : muted,

                                size: 21.sp,
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.title,

                                    style: TextStyle(
                                      color: text,

                                      fontSize: 13.sp,

                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  SizedBox(height: 3.h),

                                  Text(
                                    item.subtitle,

                                    style: TextStyle(
                                      color: muted,

                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),

                              child: isSelected
                                  ? Container(
                                      key: const ValueKey('selected'),

                                      width: 25.w,

                                      height: 25.w,

                                      decoration: BoxDecoration(
                                        color: primary,

                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(
                                        Icons.check_rounded,

                                        color: darkMode
                                            ? const Color(0xFF10201A)
                                            : Colors.white,

                                        size: 15.sp,
                                      ),
                                    )
                                  : Container(
                                      key: const ValueKey('empty'),

                                      width: 18.w,

                                      height: 18.w,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        border: Border.all(
                                          color: muted.withValues(alpha: .45),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.auto_awesome_rounded, size: 14.sp, color: gold),

                  SizedBox(width: 6.w),

                  Text(
                    'يمكن تغيير النمط في أي وقت',

                    style: TextStyle(color: muted, fontSize: 9.5.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
