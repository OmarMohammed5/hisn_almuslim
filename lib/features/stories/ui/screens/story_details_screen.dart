import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:flutter/services.dart';
import '../../../../core/helpers/story_share_data.dart';
import '../../../../core/helpers/story_share_helper.dart';
import '../../../../core/shared/custom_snack_bar.dart';
import '../../domain/entities/prophet_story.dart';
import '../widgets/reading_toolbar.dart';
import '../widgets/story_header.dart';
import '../widgets/story_navigation.dart';

class StoryDetailsScreen extends StatefulWidget {
  final ProphetStory story;
  final List<ProphetStory> allStories;
  final int currentIndex;

  const StoryDetailsScreen({
    Key? key,
    required this.story,
    required this.allStories,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  late double _fontSize;
  late int _currentIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fontSize = 18.0;
    _currentIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToStory(int index) {
    if (index >= 0 && index < widget.allStories.length) {
      setState(() {
        _currentIndex = index;
      });
      _scrollController.jumpTo(0);
    }
  }

  void _shareStory() {
    final story = widget.allStories[_currentIndex];
    StoryShareHelper.showShareOptions(
      context,
      data: StoryShareData(
        title: story.prophet,
        content: story.story,
        category: 'قصص الأنبياء',
        story: story,
        currentIndex: _currentIndex,
        totalStories: widget.allStories.length,
      ),
    );
  }

  void _copyStory() {
    final story = widget.allStories[_currentIndex];
    Clipboard.setData(ClipboardData(text: '${story.prophet}\n\n${story.story}'));
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
          'تم نسخ القصة',
        Icons.check_circle,
        context,
        lightColor: Colors.teal,
        darkColor: Colors.teal.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.allStories[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == widget.allStories.length - 1;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBarWidget(title:   'قصص الأنبياء',),
      body: Column(
        children: [
          // Minimal header
          StoryHeader(
            story: story,
            currentIndex: _currentIndex,
            totalStories: widget.allStories.length,
          ),

          // Story content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    story.story,
                    style: TextStyle(
                      fontSize: _fontSize.sp,
                      height: 2.0,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontFamily: 'QuranFont',
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20.h),

                  // Subtle end marker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20.w,
                        height: 1.h,
                        color: primaryColor.withOpacity(0.2),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.star_rounded,
                        size: 12.sp,
                        color: primaryColor.withOpacity(0.3),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 20.w,
                        height: 1.h,
                        color: primaryColor.withOpacity(0.2),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Navigation
          StoryNavigation(
            isFirst: isFirst,
            isLast: isLast,
            currentIndex: _currentIndex,
            totalStories: widget.allStories.length,
            onPrevious: () => _navigateToStory(_currentIndex - 1),
            onNext: () => _navigateToStory(_currentIndex + 1),
          ),

          // Reading toolbar
          ReadingToolbar(
            story: story,
            fontSize: _fontSize,
            onIncreaseFontSize: () {
              setState(() {
                if (_fontSize < 30) _fontSize += 1;
              });
            },
            onDecreaseFontSize: () {
              setState(() {
                if (_fontSize > 12) _fontSize -= 1;
              });
            },
            onShare: _shareStory,
            onCopy: _copyStory,
          ),
        ],
      ),
    );
  }
}

