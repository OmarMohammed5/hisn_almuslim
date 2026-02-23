import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/al%20azkar/data/cubit/azkar_cubit.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/screen/zekr_details_screen.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/widgets/zekr_card_widget.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class HisnAlmuslimScreen extends StatefulWidget {
  const HisnAlmuslimScreen({super.key});

  @override
  State<HisnAlmuslimScreen> createState() => _HisnAlmuslimScreenState();
}

class _HisnAlmuslimScreenState extends State<HisnAlmuslimScreen> {
  /// Search Logic
  final ValueNotifier<String> searchQuery = ValueNotifier('');

  String normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[ًٌٍَُِّْـ]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .trim();
  }

  List<dynamic> filterAzkar(List<dynamic> zekrList, String query) {
    if (query.trim().isEmpty) {
      return zekrList;
    }
    final normalizedQuery = normalizeArabic(query.trim().toLowerCase());

    return zekrList.where((item) {
      final normalizedTitle = normalizeArabic(item.title.toLowerCase());
      return normalizedTitle.contains(normalizedQuery);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().getAzkar();
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: ValueListenableBuilder(
            valueListenable: searchQuery,
            builder: (context, value, child) {
              return SearchField(
                hint: "ابحث في الأذكار ...",
                onChanged: (v) {
                  searchQuery.value = v;
                },
              );
            },
          ),
        ),
        body: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (context, state) {
            if (state is AzkarLoading) {
              return Center(
                child: CupertinoActivityIndicator(color: Colors.teal.shade700),
              );
            } else if (state is AzkarLoaded) {
              return ValueListenableBuilder<String>(
                valueListenable: searchQuery,
                builder: (context, query, child) {
                  final filteredAzkar = filterAzkar(state.zekrList, query);

                  if (filteredAzkar.isEmpty) {
                    return Center(
                      child: CustomText(
                        'لا توجد نتائج للبحث',
                        fontSize: 18.sp,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredAzkar.length,
                    itemBuilder: (context, index) {
                      final azkar = filteredAzkar[index];
                      final originalIndex = state.zekrList.indexOf(azkar);

                      return Column(
                        children: [
                          ZekrCardWidget(
                            title: azkar.title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ZekrDetailsScreen(
                                      zekr: azkar,
                                      initialIndex: originalIndex,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            } else if (state is AzkarError) {
              return Center(
                child: CustomText(
                  state.errorMessage,
                  fontSize: 18.sp,
                  color: Colors.red,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
