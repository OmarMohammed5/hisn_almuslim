import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'story_share_card.dart';
import 'story_share_data.dart';

class StoryCardRenderer {
  StoryCardRenderer._();

  static Future<Uint8List> render({
    required BuildContext context,
    required StoryShareData data,
    required bool isDark,
  }) async {
    final repaintKey = GlobalKey();

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: -2000,
          top: 0,
          child: Material(
            color: Colors.transparent,
            child: RepaintBoundary(
              key: repaintKey,
              child: StoryShareCard(
                data: data,
                isDark: isDark,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    try {
      await WidgetsBinding.instance.endOfFrame;

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      final renderObject =
      repaintKey.currentContext?.findRenderObject();

      if (renderObject is! RenderRepaintBoundary) {
        throw Exception(
          'Story card render object not found',
        );
      }

      final image = await renderObject.toImage(
        pixelRatio: 2.0,
      );

      final byteData = await image.toByteData(
        format: ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception(
          'Failed to convert story card to PNG',
        );
      }

      return byteData.buffer.asUint8List();
    } finally {
      entry.remove();
    }
  }
}