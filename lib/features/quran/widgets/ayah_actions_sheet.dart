import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../data/cubit/ayah_highlight_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../domain/entities/surah_entity.dart';

const List<Color> kHighlightPalette = [
  Color(0xFFD9B84C),
  Color(0xFF6FAE7A),
  Color(0xFF5E91B8),
  Color(0xFFC66F63),
  Color(0xFF9672A8),
];

class AyahActionsSheet extends StatefulWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final HighlightData? currentHighlight;
  final ValueChanged<Color> onHighlight;
  final VoidCallback onRemoveHighlight;

  const AyahActionsSheet({
    super.key,
    required this.surah,
    required this.ayah,
    required this.onHighlight,
    required this.onRemoveHighlight,
    this.currentHighlight,
  });

  @override
  State<AyahActionsSheet> createState() => _AyahActionsSheetState();
}

class _AyahActionsSheetState extends State<AyahActionsSheet> {
  final AudioPlayer _player = AudioPlayer();
  bool _loading = false;
  bool _playing = false;
  bool _loop = false;
  bool _showColors = false;

  String get _audioUrl {
    if (widget.ayah.audioUrl.endsWith('.mp3')) return widget.ayah.audioUrl;
    if (widget.ayah.audioSecondary.isNotEmpty &&
        widget.ayah.audioSecondary.first.endsWith('.mp3'))
      return widget.ayah.audioSecondary.first;
    return 'https://cdn.islamic.network/quran/audio/128/ar.husary/${widget.surah.number}_${widget.ayah.numberInSurah}.mp3';
  }

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playing = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _listen() async {
    if (_playing) {
      await _player.pause();
      return;
    }
    setState(() => _loading = true);
    try {
      if (_player.state == PlayerState.paused) {
        await _player.resume();
      } else {
        await _player.play(UrlSource(_audioUrl));
      }
      await _player.setReleaseMode(
        _loop ? ReleaseMode.loop : ReleaseMode.release,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.ayah.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(14.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        content: const Text('تم نسخ الآية'),
      ),
    );
  }

  void _share() {
    ShareHelper.shareAsImage(
      context,
      widget.ayah.text,
      isDark: Theme.of(context).brightness == Brightness.dark,
      source:
          '(${widget.surah.displayName} - الآية ${widget.ayah.numberInSurah})',
      fontFamily: 'QuranFont',
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF101815) : const Color(0xFFFDFBF5);
    final surface = dark ? const Color(0xFF17211D) : const Color(0xFFF0EBDC);
    final text = dark ? const Color(0xFFECE6D6) : const Color(0xFF20281F);
    final muted = dark ? const Color(0xFF96A39A) : const Color(0xFF667268);
    final primary = dark ? const Color(0xFF7EB6A8) : const Color(0xFF1F5145);
    final gold = dark ? const Color(0xFFD2B57C) : const Color(0xFFAC8E54);
    final highlighted = widget.currentHighlight != null;

    final actions = [
      _ActionTile(
        Icons.share_rounded,
        'مشاركة',
        primary,
        surface,
        text,
        _share,
      ),
      _ActionTile(Icons.copy_rounded, 'نسخ', primary, surface, text, _copy),
      _ActionTile(
        highlighted ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        highlighted ? 'تغيير' : 'تظليل',
        highlighted ? widget.currentHighlight!.color : gold,
        surface,
        text,
        () => setState(() => _showColors = !_showColors),
      ),
      _ActionTile(
        _loop ? Icons.repeat_one_rounded : Icons.repeat_rounded,
        'تكرار',
        _loop ? gold : primary,
        surface,
        text,
        () async {
          setState(() => _loop = !_loop);
          await _player.setReleaseMode(
            _loop ? ReleaseMode.loop : ReleaseMode.release,
          );
        },
      ),
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .88,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: .28),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: primary,
                      size: 21.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6.h,
                      children: [
                        CustomText(
                          'الآية ${_digits(widget.ayah.numberInSurah)}',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: text,
                        ),
                        CustomText(
                          widget.surah.displayName,
                          fontSize: 11.sp,
                          color: muted,
                        ),
                      ],
                    ),
                  ),
                  if (highlighted)
                    Container(
                      width: 11.w,
                      height: 11.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.currentHighlight!.color,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  widget.ayah.text,
                  maxLines: 50,
                  textAlign: TextAlign.center,
                  fontSize: 16.sp,
                  height: 1.95,
                  color: text,
                ),
              ),
              SizedBox(height: 10.h),

              // Listening
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: Row(
                  children: [
                    Material(
                      color: primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: _loading ? null : _listen,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: 42.w,
                          height: 42.w,
                          child: _loading
                              ? Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  _playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 7.h,
                        children: [
                          CustomText(
                            _playing ? 'جاري الاستماع' : 'استماع للآية',
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w800,
                              color: text,
                          ),
                          CustomText(
                            'الشيخ محمود خليل الحصري',
                            fontSize: 9.5.sp, color: muted,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _loop
                          ? Icons.repeat_one_rounded
                          : Icons.graphic_eq_rounded,
                      color: gold,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13.h),
              CustomText(
                'إجراءات الآية',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: muted,
              ),
              SizedBox(height: 8.h),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: .92,
                children: actions,
              ),
              if (_showColors) ...[
                SizedBox(height: 9.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 11.h,
                    horizontal: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(17.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...kHighlightPalette.map(
                        (color) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              widget.onHighlight(color);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border:
                                    widget.currentHighlight?.color == color
                                    ? Border.all(color: text, width: 2)
                                    : null,
                              ),
                              child: widget.currentHighlight?.color == color
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 17.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      if (highlighted)
                        Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              widget.onRemoveHighlight();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: .09),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 17.sp,
                                color: Colors.red.shade400,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _digits(int n) => n.toString().replaceAllMapped(
    RegExp(r'\d'),
    (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m.group(0)!)],
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color surface;
  final Color text;
  final VoidCallback onTap;

  const _ActionTile(
    this.icon,
    this.label,
    this.color,
    this.surface,
    this.text,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) => Material(
    color: surface,
    borderRadius: BorderRadius.circular(16.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .09),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18.sp, color: color),
            ),
            SizedBox(height: 5.h),
            CustomText(
              label,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ],
        ),
      ),
    ),
  );
}
