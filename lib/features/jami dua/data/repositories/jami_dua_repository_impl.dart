import '../../domain/entities/jami_dua_category.dart';
import '../../domain/repositories/jami_dua_repository.dart';
import '../datasources/jami_dua_local_data_source.dart';

class JamiDuaRepositoryImpl implements JamiDuaRepository {
  final JamiDuaLocalDataSource localDataSource;

  const JamiDuaRepositoryImpl({required this.localDataSource});

  @override
  Future<JamiDuaCategory> getCategory(JamiDuaCategoryType type) {
    return localDataSource.getCategory(type);
  }
}