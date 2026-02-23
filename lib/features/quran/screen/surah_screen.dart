// ignore_for_file: unnecessary_type_check

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/quran_progress_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_state.dart';
import 'package:hisn_almuslim/features/quran/data/models/last_page_storage.dart';
import 'package:hisn_almuslim/features/quran/service/book_mark_color_dialog.dart';
import 'package:hisn_almuslim/features/quran/service/book_mark_manager.dart';
import 'package:hisn_almuslim/features/quran/widgets/book_mark_indicator.dart';

class SurahScreen extends StatefulWidget {
  final int surahIndex;
  final int initialPage;
  const SurahScreen({
    super.key,
    required this.surahIndex,
    required this.initialPage,
  });

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  PageController? _pageController;
  bool _controllerInitialized = false;
  int? _currentPage;
  bool _showAppBar = true;
  bool _showBottomIndicator = true;

  // initialize bookMarks
  Map<int, String> _bookmarks = {};

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadSurahs();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await BookmarkManager.getBookmarks();
    if (mounted) setState(() => _bookmarks = bookmarks);
  }

  String _getPagePath(int pageNumber) {
    return 'assets/quran/Image${pageNumber.toString().padLeft(2, '0')}.png';
  }

  String _getSurahNameForPage(int page, List<dynamic> surahs) {
    for (int i = surahs.length - 1; i >= 0; i--) {
      if (surahs[i].startPage <= page) {
        return surahs[i].name;
      }
    }
    return surahs.first.name;
  }

  void _toggleUI() {
    setState(() {
      _showAppBar = !_showAppBar;
      _showBottomIndicator = !_showBottomIndicator;
    });
  }

  // Choose the color of Book Mark to load the page
  Future<void> _showBookmarkDialog() async {
    final currentPage = _currentPage ?? 1;
    final existingColor = _bookmarks[currentPage];

    final result = await showDialog<String>(
      context: context,
      builder: (_) => BookmarkColorDialog(currentColorHex: existingColor),
    );

    if (result == null) return; // Cancel

    if (result == 'remove') {
      await BookmarkManager.removeBookmark(currentPage);
    } else {
      await BookmarkManager.saveBookmark(currentPage, result);
    }

    await _loadBookmarks(); // Refresh
  }

  Color? _getBookmarkColor(int page) {
    final hex = _bookmarks[page];
    if (hex == null) return null;
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        if (state is QuranLoading) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        }

        if (state is QuranLoaded) {
          final surah = state.surahs[widget.surahIndex];
          final startPage = surah.startPage;

          // _currentPage ??= startPage;
          _currentPage ??= widget.initialPage > 0
              ? widget.initialPage
              : startPage;

          if (!_controllerInitialized) {
            _pageController = PageController(
              initialPage: (widget.initialPage) - 1,
            );
            _controllerInitialized = true;
          }

          final bookmarkColor = _getBookmarkColor(_currentPage!);

          final currentSurahName = _getSurahNameForPage(
            _currentPage!,
            state.surahs,
          );

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: const Color(0xFFF7F3E8),
            appBar: _showAppBar
                ? AppBar(
                    backgroundColor: Colors.black.withOpacity(0.7),
                    centerTitle: true,
                    title: Text(
                      currentSurahName,
                      style: const TextStyle(
                        fontFamily: "Al mushaf",
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    actions: [
                      // Bookmark
                      IconButton(
                        onPressed: _showBookmarkDialog,
                        icon: Icon(
                          bookmarkColor != null
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: bookmarkColor ?? Colors.white,
                          size: 28,
                        ),
                        tooltip: 'إضافة علامة',
                      ),
                      surah.type == "مدنية"
                          ? Image.asset(
                              "assets/icons/Madina.png",
                              width: 40.w,
                              height: 40.h,
                            )
                          : Image.asset(
                              "assets/icons/Makka.png",
                              width: 40.w,
                              height: 40.h,
                            ),
                    ],
                    iconTheme: const IconThemeData(color: Colors.white),
                  )
                : null,
            body: GestureDetector(
              onTap: _toggleUI,
              child: Stack(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PageView.builder(
                      controller: _pageController,
                      reverse: true,
                      itemCount: 604,

                      onPageChanged: (index) {
                        setState(() => _currentPage = index + 1);
                        LastPageStorage.savePage(index + 1);
                        if (state is QuranLoaded) {
                          context.read<QuranProgressCubit>().updateCurrentPage(
                            index + 1,
                            (state).surahs,
                          );
                        }
                      },

                      itemBuilder: (context, index) {
                        final pageNumber = index + 1;
                        return Image.asset(
                          _getPagePath(pageNumber),
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),

                  // Top Left of Screen
                  if (bookmarkColor != null)
                    BookmarkIndicator(color: bookmarkColor),

                  // Number of Page
                  if (_showBottomIndicator)
                    Positioned(
                      bottom: 20.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'صفحة  $_currentPage',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Cairo",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
