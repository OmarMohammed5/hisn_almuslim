import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/app_responsive.dart';

class LecturesScreenSkeleton extends StatelessWidget {
  const LecturesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade300,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade100,
      enabled: true,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppResponsive.widthValue(context, 18),
          AppResponsive.heightValue(context, 18),
          AppResponsive.widthValue(context, 18),
          AppResponsive.heightValue(context, 40),
        ),
        children: [
          // Continue Listening Skeleton
          _buildContinueListeningSkeleton(context),
          SizedBox(height: AppResponsive.heightValue(context, 30)),

          // Categories Title
          Align(
            alignment: Alignment.centerRight,
            child: _buildShimmerBox(
              width: AppResponsive.widthValue(context, 90),
              height: AppResponsive.heightValue(context, 21),
              radius: AppResponsive.radius(context, 6),
            ),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 16)),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 3 : 4,
              crossAxisSpacing: AppResponsive.widthValue(context, 10),
              mainAxisSpacing: AppResponsive.heightValue(context, 12),
              mainAxisExtent: AppResponsive.heightValue(
                context,
                isMobile ? 126 : 132,
              ),
            ),
            itemBuilder: (_, __) => _buildCategorySkeleton(context),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 38)),

          // Sheikh Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 100),
                height: AppResponsive.heightValue(context, 21),
                radius: AppResponsive.radius(context, 6),
              ),
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 45),
                height: AppResponsive.heightValue(context, 10),
                radius: AppResponsive.radius(context, 5),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.heightValue(context, 16)),

          // Sheikh Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 3 : 4,
              crossAxisSpacing: AppResponsive.widthValue(context, 10),
              mainAxisSpacing: AppResponsive.heightValue(context, 12),
              mainAxisExtent: AppResponsive.heightValue(
                context,
                isMobile ? 150 : 158,
              ),
            ),
            itemBuilder: (_, __) => _buildSheikhSkeleton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildContinueListeningSkeleton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 14)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 22),
                height: AppResponsive.widthValue(context, 22),
                radius: AppResponsive.radius(context, 7),
              ),
              SizedBox(width: AppResponsive.widthValue(context, 8)),
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 105),
                height: AppResponsive.heightValue(context, 14),
                radius: AppResponsive.radius(context, 5),
              ),
              const Spacer(),
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 42),
                height: AppResponsive.heightValue(context, 11),
                radius: AppResponsive.radius(context, 5),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.heightValue(context, 14)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 105),
                height: AppResponsive.heightValue(context, 72),
                radius: AppResponsive.radius(context, 14),
              ),
              SizedBox(width: AppResponsive.widthValue(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(
                      width: double.infinity,
                      height: AppResponsive.heightValue(context, 13),
                      radius: AppResponsive.radius(context, 5),
                    ),
                    SizedBox(height: AppResponsive.heightValue(context, 8)),
                    _buildShimmerBox(
                      width: AppResponsive.widthValue(context, 145),
                      height: AppResponsive.heightValue(context, 11),
                      radius: AppResponsive.radius(context, 5),
                    ),
                    SizedBox(height: AppResponsive.heightValue(context, 8)),
                    _buildShimmerBox(
                      width: AppResponsive.widthValue(context, 95),
                      height: AppResponsive.heightValue(context, 9),
                      radius: AppResponsive.radius(context, 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.heightValue(context, 14)),
          _buildShimmerBox(
            width: double.infinity,
            height: AppResponsive.heightValue(context, 5),
            radius: AppResponsive.radius(context, 10),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 12)),
          Row(
            children: [
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 70),
                height: AppResponsive.heightValue(context, 10),
                radius: AppResponsive.radius(context, 5),
              ),
              const Spacer(),
              _buildShimmerBox(
                width: AppResponsive.widthValue(context, 85),
                height: AppResponsive.heightValue(context, 34),
                radius: AppResponsive.radius(context, 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySkeleton(BuildContext context) {
    return Container(
      height: AppResponsive.heightValue(context, 118),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 52),
            height: AppResponsive.widthValue(context, 52),
            radius: AppResponsive.radius(context, 100),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 12)),
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 70),
            height: AppResponsive.heightValue(context, 11),
            radius: AppResponsive.radius(context, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildSheikhSkeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.heightValue(context, 12),
        horizontal: AppResponsive.widthValue(context, 8),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 58),
            height: AppResponsive.widthValue(context, 58),
            radius: AppResponsive.radius(context, 100),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 9)),
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 70),
            height: AppResponsive.heightValue(context, 10),
            radius: AppResponsive.radius(context, 5),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 7)),
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 45),
            height: AppResponsive.heightValue(context, 8),
            radius: AppResponsive.radius(context, 5),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 9)),
          _buildShimmerBox(
            width: AppResponsive.widthValue(context, 12),
            height: AppResponsive.widthValue(context, 12),
            radius: AppResponsive.radius(context, 100),
          ),
        ],
      ),
    );
  }
}
