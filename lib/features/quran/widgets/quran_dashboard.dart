import 'package:flutter/material.dart';
import 'package:hisn_almuslim/features/quran/data/models/last_page_storage.dart';
import 'package:hisn_almuslim/features/quran/data/models/surah_model.dart';
import 'package:hisn_almuslim/features/quran/widgets/build_progress_state.dart';

class QuranProgressDashboard extends StatefulWidget {
  final List<SurahModel> surahs;

  const QuranProgressDashboard({super.key, required this.surahs});

  @override
  State<QuranProgressDashboard> createState() => _QuranProgressDashboardState();
}

class _QuranProgressDashboardState extends State<QuranProgressDashboard> {
  int _lastPage = 0;
  String _surahName = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(QuranProgressDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _load();
  }

  Future<void> _load() async {
    final page = await LastPageStorage.loadPage();
    if (page == 0) return;

    setState(() {
      _lastPage = page;
      _surahName = _getSurahName(page);
    });
  }

  String _getSurahName(int page) {
    for (int i = widget.surahs.length - 1; i >= 0; i--) {
      if (widget.surahs[i].startPage <= page) {
        return widget.surahs[i].name;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _lastPage == 0
          ? SizedBox.shrink()
          : BuildProgressState(
              widget: widget,
              context: context,
              isDark: isDark,
              lastPage: _lastPage,
              surahName: _surahName,
            ),
    );
  }
}
