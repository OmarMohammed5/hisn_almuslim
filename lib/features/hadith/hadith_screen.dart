import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_book.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_route_args.dart';
import 'package:hisn_almuslim/features/hadith/widgets/book_card.dart';
import '../../core/shared/app_bar_widget.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
            ? 820.0
            : double.infinity;

    void openBook(HadithBookType book) {
      Navigator.pushNamed(
        context,
        AppRoutes.hadithIndex,
        arguments: HadithIndexArgs(book: book),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(title: 'الأَحَادِيثُ النَّبَوِيَّةُ'),
        body: AppResponsive.constrain(
          context,
          maxWidth: maxWidth,
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.widthValue(context, 16),
                    vertical: AppResponsive.heightValue(context, 16),
                  ),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppResponsive.heightValue(context, 16),
                  crossAxisSpacing: AppResponsive.widthValue(context, 20),
                  childAspectRatio: 0.83,
                  children: [
                    BookCard(
                      onTap: () => openBook(HadithBookType.bukhary),
                      title: HadithBook.bukhary.title,
                      subtitle: HadithBook.bukhary.subtitle,
                      number: HadithBook.bukhary.number,
                    ),
                    BookCard(
                      onTap: () => openBook(HadithBookType.muslim),
                      title: HadithBook.muslim.title,
                      subtitle: HadithBook.muslim.subtitle,
                      number: HadithBook.muslim.number,
                    ),
                    BookCard(
                      onTap: () => openBook(HadithBookType.riyadAlSaliheen),
                      title: HadithBook.riyadAlSaliheen.title,
                      subtitle: HadithBook.riyadAlSaliheen.subtitle,
                      number: HadithBook.riyadAlSaliheen.number,
                    ),
                    BookCard(
                      onTap: () => openBook(HadithBookType.nawawi),
                      title: HadithBook.nawawi.title,
                      subtitle: HadithBook.nawawi.subtitle,
                      number: HadithBook.nawawi.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
