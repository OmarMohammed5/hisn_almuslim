import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const _latKey = 'last_lat';
  static const _lngKey = 'last_lng';
  static const _hasGrantedOnceKey = 'location_granted_once';

  static Future<({double lat, double lng})> getCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    final grantedBefore = prefs.getBool(_hasGrantedOnceKey) ?? false;

    try {
      final position = await _getCurrentPosition();
      await _saveLastKnown(prefs, position.latitude, position.longitude);
      if (!grantedBefore) {
        await prefs.setBool(_hasGrantedOnceKey, true);
      }
      return (lat: position.latitude, lng: position.longitude);
    } on LocationServiceDisabledException {
      if (grantedBefore) {
        final cached = _getLastKnown(prefs);
        if (cached != null) return cached;
      }
      rethrow;
    } on PermissionDeniedException {
      if (grantedBefore) {
        final cached = _getLastKnown(prefs);
        if (cached != null) return cached;
      }
      rethrow;
    } catch (e) {
      final cached = _getLastKnown(prefs);
      if (cached != null) return cached;
      rethrow;
    }
  }

  static Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException('تم رفض إذن الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException('إذن الموقع مرفوض بشكل دائم');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  static Future<void> _saveLastKnown(
      SharedPreferences prefs,
      double lat,
      double lng,
      ) async {
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
  }

  static ({double lat, double lng})? _getLastKnown(SharedPreferences prefs) {
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    if (lat == null || lng == null) return null;
    return (lat: lat, lng: lng);
  }
}