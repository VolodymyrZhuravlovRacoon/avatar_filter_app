import 'dart:math';

import '../../domain/entities/avatar.dart';

class MockAvatarDataSource {
  Future<List<Avatar>> getAvatars() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final List<String> poses = [
      'Standing',
      'Sitting',
      'Selfie',
      'Car selfie',
      'Walking',
    ];
    final List<String> names = [
      'Olivia',
      'Liam',
      'Emma',
      'Noah',
      'Amelia',
      'Oliver',
      'Sophia',
      'Elijah',
      'Charlotte',
      'Mateo',
      'Isabella',
      'Lucas',
      'Mia',
      'Levi',
      'Ava',
      'Leo'
    ];
    final Random random = Random();

    int getRandomAge() => 18 + random.nextInt(60);
    String getRandomPose() => poses[random.nextInt(poses.length)];
    String getRandomName() => names[random.nextInt(names.length)];

    return List.generate(16, (index) {
      return Avatar(
        id: (index + 1).toString(),
        name: getRandomName(),
        imageUrl: 'https://i.pravatar.cc/300?img=${index + 1}',
        age: getRandomAge(),
        gender: random.nextBool() ? 'Male' : 'Female',
        pose: getRandomPose(),
      );
    });
  }
}
