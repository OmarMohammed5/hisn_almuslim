import '../entities/jami_dua_category.dart';

abstract class JamiDuaRepository {
  Future<JamiDuaCategory> getCategory(JamiDuaCategoryType type);
}