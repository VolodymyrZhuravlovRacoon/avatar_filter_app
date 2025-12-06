import 'package:flutter/foundation.dart';

@immutable
class Avatar {
  final String id;
  final String name;
  final String imageUrl;
  final int age;
  final String gender;
  final String pose;

  const Avatar({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.age,
    required this.gender,
    required this.pose,
  });
}
