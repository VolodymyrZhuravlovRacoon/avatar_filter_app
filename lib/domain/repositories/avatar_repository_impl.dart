import 'package:avatar_filter_app/data/datasources/mock_avatar_datasource.dart';

import '../../domain/entities/avatar.dart';
import '../../domain/repositories/avatar_repository.dart';

class AvatarRepositoryImpl implements AvatarRepository {
  final MockAvatarDataSource dataSource;

  AvatarRepositoryImpl(this.dataSource);

  @override
  Future<List<Avatar>> getAvatars() async {
    return await dataSource.getAvatars();
  }
}
