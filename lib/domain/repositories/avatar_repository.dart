import '../entities/avatar.dart';

// Абстрактний контракт для отримання даних про аватари
abstract class AvatarRepository {
  Future<List<Avatar>> getAvatars();
}
