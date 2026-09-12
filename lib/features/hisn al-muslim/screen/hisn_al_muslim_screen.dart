import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/core/utils/arabic_search_utils.dart';
import 'package:hisn_almuslim/features/al%20azkar/data/cubit/azkar_cubit.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/widgets/zekr_card_widget.dart';
import '../../../core/responsive/app_responsive.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../core/shared/search_field.dart';

class HisnAlmuslimScreen extends StatefulWidget {
  const HisnAlmuslimScreen({super.key});

  @override
  State<HisnAlmuslimScreen> createState() => _HisnAlmuslimScreenState();
}

class _HisnAlmuslimScreenState extends State<HisnAlmuslimScreen> {
  String searchQuery = '';

  /// Scroll
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });

    // Load Azkar.
    context.read<AzkarCubit>().getAzkar();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _showScrollToTop.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: AppResponsive.heightValue(context, 80),
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: Padding(
            padding: EdgeInsets.only(
              top: AppResponsive.heightValue(context, 12),
              bottom: AppResponsive.heightValue(context, 12),
            ),
            child: BuildBackButton(
              context: context,
              iconColor: isDark ? Colors.white : Colors.black87,
            ),
          ),

          title: SearchField(
            hint: 'ابحث في الأذكار ...',
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),

        body: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (context, state) {
            // Loading


            if (state is AzkarLoading) {
              return Center(
                child: CupertinoActivityIndicator(color: AppColors.kPrimary),
              );
            }

            // Loaded

            if (state is AzkarLoaded) {
              final filteredAzkar = state.zekrList.where((zekr) {
                return ArabicSearchUtils.matches(
                  title: zekr.title,
                  query: searchQuery,
                );
              }).toList();

              // No Results

              if (filteredAzkar.isEmpty) {
                return Center(
                  child: CustomText(
                    'لا توجد نتائج للبحث',
                    fontSize: AppResponsive.fontSize(context, 14),
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                );
              }

              // Results
              final maxWidth = AppResponsive.isDesktop(context)
                  ? 1100.0
                  : AppResponsive.isTablet(context)
                  ? 820.0
                  : double.infinity;

              return AppResponsive.constrain(
                context,
                maxWidth: maxWidth,
                child: ListView.builder(
                  padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
                  itemCount: filteredAzkar.length,
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final azkar = filteredAzkar[index];

                    final originalIndex = state.zekrList.indexOf(azkar);

                    return ZekrCardWidget(
                      title: azkar.title,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.zekrDetails,
                          arguments: {
                            'zekr': azkar,
                            'initialIndex': originalIndex,
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }

            // Error

            if (state is AzkarError) {
              return Center(
                child: CustomText(
                  state.errorMessage,
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: Colors.red,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: ReBuildScrollToTop(
          showScrollToTop: _showScrollToTop,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
