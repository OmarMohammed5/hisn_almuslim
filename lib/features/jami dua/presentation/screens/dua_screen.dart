import 'package:flutter/material.dart';

import '../../domain/entities/jami_dua_category.dart';
import '../../domain/entities/jami_dua_category_factory.dart';
import '../../domain/entities/jami_dua_route_args.dart';
import '../../widgets/category_card.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/responsive/app_responsive.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  static const _categories = JamiDuaCategoryFactory.definitions;

  void _openCategory(BuildContext context, JamiDuaCategoryType type) {
    Navigator.pushNamed(
      context,
      AppRoutes.duaDetails,
      arguments: JamiDuaDetailsArgs(category: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'الأدعية'),
      body: AppResponsive.constrain(
        context,
        maxWidth: 1200,
        child: GridView.builder(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2,
            mainAxisSpacing: AppResponsive.heightValue(context, 4),
            crossAxisSpacing: AppResponsive.widthValue(context, 8),
            mainAxisExtent: isMobile
                ? AppResponsive.heightValue(context, 76)
                : AppResponsive.heightValue(context, 82),
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];

            return CategoryCard(
              title: category.title,
              onTap: () => _openCategory(context, category.type),
            );
          },
        ),
      ),
    );
  }
}
