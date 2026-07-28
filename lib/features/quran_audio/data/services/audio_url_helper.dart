// features/quran_audio/data/services/audio_url_helper.dart

import 'package:equatable/equatable.dart';

/// Helper class for generating audio URLs
class AudioUrlHelper {
  static String generateAudioUrl(String server, int surahNumber) {
    // Validate surah number
    if (surahNumber < 1 || surahNumber > 114) {
      throw ArgumentError(
        'Surah number must be between 1 and 114. Got: $surahNumber',
      );
    }

    // Format surah number as 3 digits (001, 002, ..., 114)
    final String surahFormatted = surahNumber.toString().padLeft(3, '0');

    // Build the complete URL
    return '$server/$surahFormatted.mp3';
  }

  static AudioUrlResult generateAudioUrlSafe(String server, int surahNumber) {
    try {
      final String url = generateAudioUrl(server, surahNumber);
      return AudioUrlResult.valid(url);
    } on ArgumentError catch (e) {
      return AudioUrlResult.invalid(e.message ?? 'Invalid surah number');
    } catch (e) {
      return AudioUrlResult.invalid('Failed to generate URL: $e');
    }
  }

  /// Validates if a generated URL looks correct
  static bool isValidAudioUrl(String url) {
    return url.endsWith('.mp3') &&
        url.contains('http') &&
        RegExp(r'\/\d{3}\.mp3$').hasMatch(url);
  }
}

/// Result class for audio URL generation
class AudioUrlResult extends Equatable {
  final String? url;
  final String? error;
  final bool isValid;

  const AudioUrlResult._({this.url, this.error, this.isValid = false});

  /// Creates a valid result
  factory AudioUrlResult.valid(String url) {
    return AudioUrlResult._(url: url, isValid: true);
  }

  /// Creates an invalid result with an error message
  factory AudioUrlResult.invalid(String error) {
    return AudioUrlResult._(error: error, isValid: false);
  }

  @override
  List<Object?> get props => [url, error, isValid];
}
