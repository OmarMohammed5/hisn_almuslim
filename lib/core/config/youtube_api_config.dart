import 'package:flutter/services.dart';

class YoutubeApiConfig {
  YoutubeApiConfig._();

  static const MethodChannel _channel =
  MethodChannel('hisn_almuslim/config');

  static Future<String> get apiKey async {
    final key = await _channel.invokeMethod<String>(
      'getYoutubeApiKey',
    );

    return key?.trim() ?? '';
  }
}