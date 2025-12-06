import '../entities/avatar.dart';
import '../repositories/avatar_repository.dart';

class GetAvatars {
  final AvatarRepository repository;

  GetAvatars(this.repository);

  Future<List<Avatar>> call() async {
    return await repository.getAvatars();
  }
}
