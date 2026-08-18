import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../data/cubit/ayah_highlight_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../domain/entities/surah_entity.dart';

const List<Color> kHighlightPalette = [
  Color(0xFFFFD54F),
  Color(0xFF81C784),
  Color(0xFF64B5F6),
  Color(0xFFE57373),
  Color(0xFFBA68C8),
  Color(0xFFFF8A65),
];

class AyahActionsSheet extends StatefulWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final HighlightData? currentHighlight;
  final ValueChanged<Color> onHighlight;
  final VoidCallback onRemoveHighlight;
  final VoidCallback onTafsir;

  const AyahActionsSheet({
    super.key,
    required this.surah,
    required this.ayah,
    required this.onHighlight,
    required this.onRemoveHighlight,
    required this.onTafsir,
    this.currentHighlight,
  });

  @override
  State<AyahActionsSheet> createState() => _AyahActionsSheetState();
}

class _AyahActionsSheetState extends State<AyahActionsSheet> {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _showColorPicker = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String get _audioUrl {
    if (widget.ayah.audioUrl.endsWith('.mp3')) return widget.ayah.audioUrl;
    if (widget.ayah.audioSecondary.isNotEmpty) {
      final fallback = widget.ayah.audioSecondary.first;
      if (fallback.endsWith('.mp3')) return fallback;
    }
    return 'https://cdn.islamic.network/quran/audio/128/ar.husary/'
        '${widget.surah.number}_${widget.ayah.numberInSurah}.mp3';
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      return;
    }
    if (_player.state == PlayerState.paused) {
      await _player.resume();
      return;
    }
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await _player.play(UrlSource(_audioUrl));
    } catch (_) {
      setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _copyAyah() {
    Clipboard.setData(ClipboardData(text: widget.ayah.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('تم نسخ الآية', style: TextStyle(fontSize: 14.sp)),
      ),
    );
  }

  void _shareAyah() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, widget.ayah.text, isDark: isDark , source: '(${widget.surah.displayName} - الآية ${widget.ayah.numberInSurah})',
        fontFamily: "QuranFont");
  }

  @override
  Widget build(BuildContext context) {
    final hasHighlight = widget.currentHighlight != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade400)
                  ),
                  child: Center(
                    child: Text(
                      widget.ayah.text,
                      style: TextStyle(
                        fontFamily: 'QuranFont',
                        fontSize: 19.sp,
                        height: 1.5.h,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Audio
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  _isLoading
                      ? Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : IconButton(
                    onPressed: _togglePlay,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      size: 30.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _hasError ? 'تعذّر تشغيل الصوت' : 'الشيخ محمود خليل الحصري',
                      style: TextStyle(fontSize: 13.sp, color: _hasError ? Colors.red[400] : null),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Color picker
            if (_showColorPicker) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final color in kHighlightPalette)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: GestureDetector(
                          onTap: () {
                            widget.onHighlight(color);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: widget.currentHighlight?.color == color
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    if (hasHighlight)
                      IconButton(
                        onPressed: () {
                          widget.onRemoveHighlight();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, size: 20.sp, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],

            // Actions
            Row(
              children: [
                _actionButton(Icons.copy, 'نسخ', _copyAyah),
                _actionButton(Icons.share, 'مشاركة', _shareAyah),
                _actionButton(
                  hasHighlight ? Icons.bookmark : Icons.bookmark_border,
                  hasHighlight ? 'تغيير اللون' : 'إضافة تظليل',
                      () => setState(() => _showColorPicker = !_showColorPicker),
                  color: hasHighlight ? widget.currentHighlight!.color : null,
                ),
                if (hasHighlight)
                  _actionButton(
                    Icons.delete_outline,
                    'إزالة',
                        () {
                      widget.onRemoveHighlight();
                      Navigator.pop(context);
                    },
                    color: Colors.red[300],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            children: [
              Icon(icon, size: 26.sp, color: color),
              SizedBox(height: 4.h),
              Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}