import 'package:flutter/material.dart';

import 'story_share_data.dart';

class StoryShareCard extends StatelessWidget {
  final StoryShareData data;
  final bool isDark;

  const StoryShareCard({
    super.key,
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final background = isDark
        ? const Color(0xFF101515)
        : const Color(0xFFF8FAF9);

    final primary = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF151817);

    final bodyColor = isDark
        ? Colors.white.withValues(alpha: 0.82)
        : const Color(0xFF303635);



    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 1080,
        height: 1350,
        padding: const EdgeInsets.all(70),
        color: background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    data.category,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),

                Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.yellow.shade800,
                      width: 1.2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      width: 74,
                      "assets/icons/loogo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 65),

            // =====================================================
            // TITLE
            // =====================================================

            Text(
              data.title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 58,
                fontWeight: FontWeight.w800,
                color: titleColor,
                fontFamily: 'QuranFont',
                height: 1.3,
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 45),

            // =====================================================
            // STORY PREVIEW
            // =====================================================

            Expanded(
              child: Text(
                _getPreview(data.content),
                style: TextStyle(
                  fontSize: 34,
                  height: 2.0,
                  color: bodyColor,
                  fontFamily: 'QuranFont',
                ),
                textAlign: TextAlign.justify,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // =====================================================
            // FOOTER
            // =====================================================

            const Divider(),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اقرأ القصة كاملة في حصن المسلم',
                  style: TextStyle(
                    fontSize: 21,
                    color: bodyColor.withValues(alpha: 0.55),
                    fontFamily: 'QuranFont',
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }


  String _getPreview(String text) {
    final cleanText = text
        .replaceAll(RegExp(r'\n+'), '\n')
        .trim();

    if (cleanText.length <= 650) {
      return cleanText;
    }

    return '${cleanText.substring(0, 650).trim()}...';
  }
}