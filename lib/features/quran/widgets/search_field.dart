import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/search_cubit.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  const SearchField({super.key, required this.onChanged, required this.hint});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SearchCubit, String>(
      builder: (context, query) {
        if (controller.text != query) {
          controller.value = controller.value.copyWith(
            text: query,
            selection: TextSelection.collapsed(offset: query.length),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1c2227) : Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isDark ? Color(0xff1c2227) : Colors.white,
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                /// 🔍 Search Icon Container
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1c2227) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.search,
                    color: isDark ? Colors.white : Colors.grey,
                    size: 20.sp,
                  ),
                ),

                Gap(12.w),

                /// 📝 TextField
                Expanded(
                  child: TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: controller,
                    onChanged: (value) {
                      context.read<SearchCubit>().update(value);
                      widget.onChanged(value);
                    },
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontFamily: "Cairo",
                    ),
                    cursorColor: Colors.teal.shade700,

                    decoration: InputDecoration(
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                context.read<SearchCubit>().clear();
                                widget.onChanged('');
                              },
                            )
                          : null,

                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey,
                        fontSize: 12.sp,
                      ),
                      border: InputBorder.none,
                      fillColor: isDark ? Color(0xFF24272b) : Color(0xffe9eef0),
                      // Color(0xffe9eef0),
                      // focusedBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal.shade800,
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25.r)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark ? Color(0xFF2b2b2b) : Color(0xffe9eef0),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25.r)),
                      ),
                      // enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
