import 'package:hisn_almuslim/core/constant/app_constants.dart';
import '../../domain/entities/radio_station.dart';

abstract class RadioLocalDataSource {
  Future<RadioStation> getCairoQuranRadio();
}

class RadioLocalDataSourceImpl implements RadioLocalDataSource {
  @override
  Future<RadioStation> getCairoQuranRadio() async {
    return const RadioStation(
      id: 'cairo_quran_radio',
      name: 'إذاعة القرآن الكريم من القاهرة',
      streamUrl: AppConstants.radioUrl,
    );
  }
}