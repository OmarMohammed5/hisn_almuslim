import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/utils/arabic_search_utils.dart';

import 'package:hisn_almuslim/features/al%20azkar/data/cubit/azkar_cubit.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/screen/zekr_details_screen.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/widgets/zekr_card_widget.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';

class HisnAlmuslimScreen extends StatefulWidget {
  const HisnAlmuslimScreen({super.key});

  @override
  State<HisnAlmuslimScreen> createState() => _HisnAlmuslimScreenState();
}

class _HisnAlmuslimScreenState extends State<HisnAlmuslimScreen> {

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Load Azkar.
    context.read<AzkarCubit>().getAzkar();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isDark
                  ? Colors.white
                  : Colors.black87,
              size: 18.sp,
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
                child: CupertinoActivityIndicator(
                  color: Colors.teal.shade700,
                ),
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
                    fontSize: 18.sp,
                    color: isDark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                );
              }

              // Results

              return ListView.builder(
                itemCount: filteredAzkar.length,
                physics: const BouncingScrollPhysics(),

                itemBuilder: (context, index) {
                  final azkar = filteredAzkar[index];


                  final originalIndex =
                  state.zekrList.indexOf(azkar);

                  return ZekrCardWidget(
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
                  );
                },
              );
            }

            // Error

            if (state is AzkarError) {
              return Center(
                child: CustomText(
                  state.errorMessage,
                  fontSize: 18.sp,
                  color: Colors.red,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}