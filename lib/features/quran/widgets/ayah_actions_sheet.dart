// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hisn_almuslim/core/helpers/share_helper.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../data/cubit/ayah_highlight_state.dart';
// import '../domain/entities/ayah_entity.dart';
// import '../domain/entities/surah_entity.dart';
//
// const List<Color> kHighlightPalette = [
//   Color(0xFFFFD54F),
//   Color(0xFF81C784),
//   Color(0xFF64B5F6),
//   Color(0xFFE57373),
//   Color(0xFFBA68C8),
//   Color(0xFFFF8A65),
// ];
//
// class AyahActionsSheet extends StatefulWidget {
//   final SurahEntity surah;
//   final AyahEntity ayah;
//   final HighlightData? currentHighlight;
//   final ValueChanged<Color> onHighlight;
//   final VoidCallback onRemoveHighlight;
//   final VoidCallback onTafsir;
//
//   const AyahActionsSheet({
//     super.key,
//     required this.surah,
//     required this.ayah,
//     required this.onHighlight,
//     required this.onRemoveHighlight,
//     required this.onTafsir,
//     this.currentHighlight,
//   });
//
//   @override
//   State<AyahActionsSheet> createState() => _AyahActionsSheetState();
// }
//
// class _AyahActionsSheetState extends State<AyahActionsSheet> {
//   final AudioPlayer _player = AudioPlayer();
//   bool _isLoading = false;
//   bool _isPlaying = false;
//   bool _hasError = false;
//   bool _showColorPicker = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _player.onPlayerStateChanged.listen((state) {
//       if (!mounted) return;
//       setState(() => _isPlaying = state == PlayerState.playing);
//     });
//   }
//
//   @override
//   void dispose() {
//     _player.stop();
//     _player.dispose();
//     super.dispose();
//   }
//
//   String get _audioUrl {
//     if (widget.ayah.audioUrl.endsWith('.mp3')) return widget.ayah.audioUrl;
//     if (widget.ayah.audioSecondary.isNotEmpty) {
//       final fallback = widget.ayah.audioSecondary.first;
//       if (fallback.endsWith('.mp3')) return fallback;
//     }
//     return 'https://cdn.islamic.network/quran/audio/128/ar.husary/'
//         '${widget.surah.number}_${widget.ayah.numberInSurah}.mp3';
//   }
//
//   Future<void> _togglePlay() async {
//     if (_isPlaying) {
//       await _player.pause();
//       return;
//     }
//     if (_player.state == PlayerState.paused) {
//       await _player.resume();
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//     try {
//       await _player.play(UrlSource(_audioUrl));
//     } catch (_) {
//       setState(() => _hasError = true);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   void _copyAyah() {
//     Clipboard.setData(ClipboardData(text: widget.ayah.text));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text('تم نسخ الآية', style: TextStyle(fontSize: 14.sp)),
//       ),
//     );
//   }
//
//   void _shareAyah() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     ShareHelper.shareAsImage(
//       context,
//       widget.ayah.text,
//       isDark: isDark,
//       source:
//           '(${widget.surah.displayName} - الآية ${widget.ayah.numberInSurah})',
//       fontFamily: "QuranFont",
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final hasHighlight = widget.currentHighlight != null;
//
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.85,
//       ),
//       padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Center(
//               child: Container(
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.h),
//
//             Flexible(
//               child: SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.ayah.text,
//                       style: TextStyle(
//                         fontFamily: 'QuranFont',
//                         fontSize: 19.sp,
//                         height: 1.5.h,
//                       ),
//                       textAlign: TextAlign.right,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 12.h),
//
//             // Audio
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Row(
//                 children: [
//                   _isLoading
//                       ? Padding(
//                           padding: EdgeInsets.all(8.w),
//                           child: SizedBox(
//                             width: 22.w,
//                             height: 22.w,
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         )
//                       : IconButton(
//                           onPressed: _togglePlay,
//                           icon: Icon(
//                             _isPlaying
//                                 ? Icons.pause_circle_filled
//                                 : Icons.play_circle_fill,
//                             size: 30.sp,
//                           ),
//                         ),
//                   Expanded(
//                     child: Text(
//                       _hasError
//                           ? 'تعذّر تشغيل الصوت'
//                           : 'الشيخ محمود خليل الحصري',
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: _hasError ? Colors.red[400] : null,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8.h),
//
//             // Color picker
//             if (_showColorPicker) ...[
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     for (final color in kHighlightPalette)
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 4.w),
//                         child: GestureDetector(
//                           onTap: () {
//                             widget.onHighlight(color);
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             width: 30.w,
//                             height: 30.w,
//                             decoration: BoxDecoration(
//                               color: color,
//                               shape: BoxShape.circle,
//                               border: widget.currentHighlight?.color == color
//                                   ? Border.all(color: Colors.black, width: 2)
//                                   : null,
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (hasHighlight)
//                       IconButton(
//                         onPressed: () {
//                           widget.onRemoveHighlight();
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           size: 20.sp,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//
//             // Actions
//             Row(
//               children: [
//                 _actionButton(Icons.copy, 'نسخ', _copyAyah),
//                 _actionButton(Icons.share, 'مشاركة', _shareAyah),
//                 _actionButton(
//                   hasHighlight ? Icons.bookmark : Icons.bookmark_border,
//                   hasHighlight ? 'تغيير اللون' : 'إضافة تظليل',
//                   () => setState(() => _showColorPicker = !_showColorPicker),
//                   color: hasHighlight ? widget.currentHighlight!.color : null,
//                 ),
//                 if (hasHighlight)
//                   _actionButton(Icons.delete_outline, 'إزالة', () {
//                     widget.onRemoveHighlight();
//                     Navigator.pop(context);
//                   }, color: Colors.red[300]),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _actionButton(
//     IconData icon,
//     String label,
//     VoidCallback onTap, {
//     Color? color,
//   }) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.r),
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           child: Column(
//             children: [
//               Icon(icon, size: 26.sp, color: color),
//               SizedBox(height: 4.h),
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';

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

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String get _audioUrl {
    if (widget.ayah.audioUrl.endsWith('.mp3')) {
      return widget.ayah.audioUrl;
    }

    if (widget.ayah.audioSecondary.isNotEmpty) {
      final fallback = widget.ayah.audioSecondary.first;

      if (fallback.endsWith('.mp3')) {
        return fallback;
      }
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
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _copyAyah() {
    Clipboard.setData(
      ClipboardData(text: widget.ayah.text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(14.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        content: Text(
          'تم نسخ الآية',
          style: TextStyle(fontSize: 13.sp),
        ),
      ),
    );
  }

  void _shareAyah() {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    ShareHelper.shareAsImage(
      context,
      widget.ayah.text,
      isDark: isDark,
      source:
      '(${widget.surah.displayName} - الآية ${widget.ayah.numberInSurah})',
      fontFamily: 'QuranFont',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF101815)
        : const Color(0xFFFDFBF5);

    final surface = isDark
        ? const Color(0xFF161F1B)
        : const Color(0xFFF0EBDC);

    final text = isDark
        ? const Color(0xFFECE6D6)
        : const Color(0xFF20281F);

    final softText = isDark
        ? const Color(0xFF96A39A)
        : const Color(0xFF667268);

    final primary = isDark
        ? const Color(0xFF7EB6A8)
        : const Color(0xFF1F5145);

    final gold = isDark
        ? const Color(0xFFD2B57C)
        : const Color(0xFFAC8E54);

    final hasHighlight = widget.currentHighlight != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .88,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            10.h,
            16.w,
            16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: softText.withValues(alpha: .30),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

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
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الآية ${_arabicDigits(widget.ayah.numberInSurah)}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: text,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.surah.displayName,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: softText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasHighlight)
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.currentHighlight!.color,
                      ),
                    ),
                ],
              ),

              SizedBox(height: 15.h),

              Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  18.h,
                  16.w,
                  18.h,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: gold.withValues(alpha: .12),
                  ),
                ),
                child: Text(
                  widget.ayah.text,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'QuranFont',
                    fontSize: 20.sp,
                    height: 1.95,
                    color: text,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

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
                        customBorder: const CircleBorder(),
                        onTap: _isLoading ? null : _togglePlay,
                        child: SizedBox(
                          width: 42.w,
                          height: 42.w,
                          child: _isLoading
                              ? Padding(
                            padding: EdgeInsets.all(12.w),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 23.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasError
                                ? 'تعذر تشغيل الصوت'
                                : _isPlaying
                                ? 'جاري الاستماع'
                                : 'استماع للآية',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w800,
                              color: _hasError
                                  ? Colors.red.shade400
                                  : text,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'الشيخ محمود خليل الحصري',
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              color: softText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isPlaying)
                      Icon(
                        Icons.graphic_eq_rounded,
                        color: gold,
                        size: 22.sp,
                      ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                'إجراءات الآية',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: softText,
                ),
              ),
              SizedBox(height: 8.h),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: .95,
                children: [
                  _ActionTile(
                    icon: Icons.copy_rounded,
                    label: 'نسخ',
                    color: primary,
                    surface: surface,
                    text: text,
                    onTap: _copyAyah,
                  ),
                  _ActionTile(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    color: primary,
                    surface: surface,
                    text: text,
                    onTap: _shareAyah,
                  ),
                  _ActionTile(
                    icon: hasHighlight
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    label: hasHighlight
                        ? 'تغيير'
                        : 'تظليل',
                    color: hasHighlight
                        ? widget.currentHighlight!.color
                        : gold,
                    surface: surface,
                    text: text,
                    onTap: () {
                      setState(() {
                        _showColorPicker = !_showColorPicker;
                      });
                    },
                  ),
                  _ActionTile(
                    icon: Icons.menu_book_rounded,
                    label: 'تفسير',
                    color: primary,
                    surface: surface,
                    text: text,
                    onTap: widget.onTafsir,
                  ),
                ],
              ),

              if (_showColorPicker) ...[
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 11.h,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(17.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'اختر لون التظليل',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: softText,
                        ),
                      ),
                      SizedBox(height: 9.h),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          for (final color in kHighlightPalette)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  widget.onHighlight(color);
                                  Navigator.pop(context);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 150,
                                  ),
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: color.withValues(
                                      alpha: .88,
                                    ),
                                    shape: BoxShape.circle,
                                    border:
                                    widget.currentHighlight?.color ==
                                        color
                                        ? Border.all(
                                      color: text,
                                      width: 2,
                                    )
                                        : null,
                                  ),
                                  child:
                                  widget.currentHighlight?.color ==
                                      color
                                      ? Icon(
                                    Icons.check_rounded,
                                    size: 17.sp,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ),
                            ),
                          if (hasHighlight)
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  widget.onRemoveHighlight();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(
                                      alpha: .09,
                                    ),
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
                    ],
                  ),
                ),
              ],

              SizedBox(height: 10.h),

              if (hasHighlight)
                TextButton.icon(
                  onPressed: () {
                    widget.onRemoveHighlight();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 17.sp,
                    color: Colors.red.shade400,
                  ),
                  label: Text(
                    'إزالة التظليل',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color surface;
  final Color text;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.surface,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: color,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: text.withValues(alpha: .75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _arabicDigits(int number) {
  const map = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  return number
      .toString()
      .split('')
      .map((e) => map[e] ?? e)
      .join();
}
