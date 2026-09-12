import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/share_helper.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/shared/custom_snack_bar.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../core/utils/control_font_size.dart';
import '../../domain/entities/jami_dua_category.dart';
import '../../domain/entities/jami_dua_route_args.dart';
import '../../widgets/dua_card.dart';
import '../../widgets/etiquette_card.dart';
import '../cubit/jami_dua_cubit.dart';
import '../cubit/jami_dua_state.dart';

class DuaDetailsScreen extends StatefulWidget {
  final JamiDuaDetailsArgs args;

  const DuaDetailsScreen({super.key, required this.args});

  @override
  State<DuaDetailsScreen> createState() => _DuaDetailsScreenState();
}

class _DuaDetailsScreenState extends State<DuaDetailsScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _fontSizeNotifier = ValueNotifier<double>(18);
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier<bool>(false);

  TabController? _tabController;
  List<ScrollController> _sectionControllers = const [];
  int _activeSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    _ensureControllersForCategory(context.read<JamiDuaCubit>().state);
  }

  void _ensureControllersForCategory(JamiDuaState state) {
    if (state is! JamiDuaLoaded) return;

    final sections = state.category.sections;
    if (_sectionControllers.length == sections.length) return;

    for (final controller in _sectionControllers) {
      controller.dispose();
    }

    _sectionControllers = List.generate(
      sections.length,
      (index) => ScrollController()..addListener(_handleScroll),
    );

    if (sections.length > 1) {
      _tabController?.dispose();
      _tabController = TabController(length: sections.length, vsync: this)
        ..addListener(_handleTabChanged);
    }
  }

  void _handleScroll() {
    final controller = _currentScrollController;
    if (!controller.hasClients) return;

    final shouldShow = controller.offset > 300;
    if (_showScrollToTop.value != shouldShow) {
      _showScrollToTop.value = shouldShow;
    }
  }

  void _handleTabChanged() {
    final index = _tabController?.index ?? 0;
    if (_activeSectionIndex == index) return;

    _activeSectionIndex = index;
    _showScrollToTop.value =
        _currentScrollController.hasClients &&
        _currentScrollController.offset > 300;
  }

  ScrollController get _currentScrollController {
    if (_sectionControllers.isEmpty) {
      // This controller is only a temporary fallback before data is loaded.
      return _fallbackScrollController;
    }

    final safeIndex = _activeSectionIndex.clamp(
      0,
      _sectionControllers.length - 1,
    );
    return _sectionControllers[safeIndex];
  }

  final ScrollController _fallbackScrollController = ScrollController();

  @override
  void dispose() {
    _tabController?.dispose();

    for (final controller in _sectionControllers) {
      controller.dispose();
    }

    _fallbackScrollController.dispose();
    _fontSizeNotifier.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar('تم النسخ', Icons.check_circle_outline, context),
    );
  }

  void _shareText(String text, {required String category}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ShareHelper.shareAsImage(context, text, isDark: isDark, category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _title,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: AppResponsive.widthValue(context, 8),
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A2723)
                    : const Color(0xFFEAF2F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 14),
                  ),
                  side: BorderSide(
                    color: const Color(0xFF087F73).withValues(alpha: .14),
                  ),
                ),
              ),
              icon: Icon(
                Icons.text_fields,
                color: Colors.teal.shade700,
                size: AppResponsive.iconSize(context, 20),
              ),
              onPressed: () => FontSizeController.showFontSizeSlider(
                context: context,
                fontSizeNotifire: _fontSizeNotifier,
              ),
              splashRadius: AppResponsive.radius(context, 20),
            ),
          ),
        ],
      ),
      body: BlocConsumer<JamiDuaCubit, JamiDuaState>(
        listener: (context, state) {
          if (state is JamiDuaLoaded) {
            _ensureControllersForCategory(state);
          }
        },
        builder: (context, state) {
          if (state is JamiDuaLoading || state is JamiDuaInitial) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is JamiDuaError) {
            return Center(child: CustomText(state.message));
          }

          if (state is JamiDuaLoaded) {
            return _buildCategoryContent(state.category);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, show, _) {
          final controller = _currentScrollController;
          if (!show || !controller.hasClients) {
            return const SizedBox.shrink();
          }

          return ReBuildScrollToTop(
            showScrollToTop: _showScrollToTop,
            scrollController: controller,
          );
        },
      ),
    );
  }

  String get _title {
    switch (widget.args.category) {
      case JamiDuaCategoryType.etiquette:
        return 'آداب الدعاء';
      case JamiDuaCategoryType.quran:
        return 'أدعية من القرآن';
      case JamiDuaCategoryType.sunnah:
        return 'أدعية من السنة';
      case JamiDuaCategoryType.hajjAndOmra:
        return 'أدعية الحج و العمرة';
      case JamiDuaCategoryType.deceased:
        return 'أدعية للمتوفي';
      case JamiDuaCategoryType.lastTen:
        return 'أدعية العشر الأواخر';
    }
  }

  Widget _buildCategoryContent(JamiDuaCategory category) {
    if (!category.hasTabs) {
      return _buildSectionList(category, category.sections.first, 0);
    }

    final controller = _tabController;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildTabs(category.sections, controller),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              for (var index = 0; index < category.sections.length; index++)
                _buildSectionList(category, category.sections[index], index),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(List<JamiDuaSection> sections, TabController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 12),
        AppResponsive.heightValue(context, 8),
        AppResponsive.widthValue(context, 12),
        AppResponsive.heightValue(context, 4),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A2723)
              : const Color(0xFFEAF2F0),
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 14),
          ),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Colors.teal.shade700,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 12),
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.grey.shade700,
          labelStyle: TextStyle(
            fontFamily: 'Noon',
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Noon',
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w600,
          ),
          tabs: sections.map((section) => Tab(text: section.title)).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionList(
    JamiDuaCategory category,
    JamiDuaSection section,
    int sectionIndex,
  ) {
    return AppResponsive.constrain(
      context,
      maxWidth: 1200,
      child: ListView.builder(
        key: PageStorageKey<String>('${category.type.name}-${section.id}'),
        controller: _sectionControllers.length > sectionIndex
            ? _sectionControllers[sectionIndex]
            : _fallbackScrollController,
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),
        itemCount: section.items.length,
        itemBuilder: (context, index) {
          final item = section.items[index];

          return ValueListenableBuilder<double>(
            valueListenable: _fontSizeNotifier,
            builder: (context, fontSize, _) {
              if (item.isEtiquette) {
                return EtiquetteCard(
                  item: item,
                  fontSize: fontSize,
                  onCopy: () => _copyText(item.content),
                  onShare: () => _shareText(
                    item.content,
                    category: category.shareCategory,
                  ),
                );
              }

              return DuaCard(
                title: item.title,
                content: item.content,
                reference: item.reference,
                fontSize: fontSize,
                onCopy: () => _copyText(item.content),
                onShare: () => _shareText(
                  item.content,
                  category: category.type == JamiDuaCategoryType.hajjAndOmra
                      ? section.title
                      : category.shareCategory,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
