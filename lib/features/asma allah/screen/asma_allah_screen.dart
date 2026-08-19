import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/cubit/asma_allah_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/widgets/asma_card.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class AsmaAllahScreen extends StatefulWidget {
  const AsmaAllahScreen({super.key});

  @override
  State<AsmaAllahScreen> createState() => _AsmaAllahScreenState();
}

class _AsmaAllahScreenState extends State<AsmaAllahScreen> {
  late final PageController _controller = PageController(
    viewportFraction: 0.82,
  );
  int currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AsmaAllahCubit>().loadNames();
      }
    });
    super.initState();
  }

  void _goToNextPage(AsmaAllahLoaded loadedState) {
    if (currentIndex < loadedState.names.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AsmaAllahCubit, AsmaAllahState>(
      builder: (context, state) {
        if (state is AsmaAllahLoading) {
          return Center(
            child: CupertinoActivityIndicator(color: Colors.teal.shade700),
          );
        }

        if (state is AsmaAllahLoaded) {
          final namesList = state.names;

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0D2B2B), const Color(0xFF0A1A1A)]
                      : [const Color(0xFFE0F7F5), const Color(0xFFF5FDFC)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60.h,
                    right: -60.w,
                    child: Container(
                      width: 200.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal.withOpacity(isDark ? 0.08 : 0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80.h,
                    left: -40.w,
                    child: Container(
                      width: 260.w,
                      height: 260.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal.withOpacity(isDark ? 0.06 : 0.09),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: Colors.teal.withOpacity(0.3),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Text(
                                      "${currentIndex + 1} / ${namesList.length}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp,
                                        color: isDark
                                            ? Colors.teal.shade200
                                            : Colors.teal.shade800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Gap(40.w),
                                ],
                              ),
                              Gap(12.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: LinearProgressIndicator(
                                  value: (currentIndex + 1) / namesList.length,
                                  minHeight: 6,
                                  backgroundColor: isDark
                                      ? Colors.white12
                                      : Colors.teal.shade100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: PageView.builder(
                            pageSnapping: true,
                            controller: _controller,
                            itemCount: namesList.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final page = _controller.hasClients
                                      ? (_controller.page ?? currentIndex.toDouble())
                                      : currentIndex.toDouble();

                                  final difference = index - page;

                                  final distance = difference.abs().clamp(0.0, 1.0);

                                  final scale = 1.0 - (distance * 0.10);


                                  final opacity = 1.0 - (distance * 0.35);

                                  final translateY = distance * 18.h;

                                  final rotationY = difference * 0.08;

                                  return Center(
                                    child: Opacity(
                                      opacity: opacity.clamp(0.0, 1.0),

                                      child: Transform.translate(
                                        offset: Offset(0, translateY),
                                        child: Transform.scale(
                                          scale: scale,

                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateY(rotationY),

                                            child: child,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },

                                child: AsmaCard(
                                  key: ValueKey(index),
                                  model: namesList[index],
                                  onTap: () => _goToNextPage(state),
                                ),
                              );
                            },

                          ),
                        ),

                        // Swipe hint
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Text(
                            "اسحب للتنقل",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? Colors.white30
                                  : Colors.teal.shade300,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AsmaAllahError) {
          return Center(child: CustomText(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}