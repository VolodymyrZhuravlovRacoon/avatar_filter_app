import 'package:flutter/material.dart';

import '../../domain/entities/avatar.dart';
import '../../domain/usecases/get_avatars.dart';

class ActiveFilters {
  String? gender;
  String? age;
  String? pose;

  bool get isAnyFilterActive => gender != null || age != null || pose != null;

  void clear() {
    gender = null;
    age = null;
    pose = null;
  }
}

class AvatarProvider with ChangeNotifier {
  final GetAvatars _getAvatars;
  final ActiveFilters _filters = ActiveFilters();

  List<Avatar> _allAvatars = [];
  List<Avatar> _filteredAvatars = [];
  bool _isLoading = true;

  AvatarProvider(this._getAvatars) {
    fetchAvatars();
  }

  bool get isLoading => _isLoading;
  List<Avatar> get filteredAvatars => _filteredAvatars;
  ActiveFilters get filters => _filters;
  int get filteredAvatarsCount => _filteredAvatars.length;

  Future<void> fetchAvatars() async {
    _isLoading = true;
    notifyListeners();
    _allAvatars = await _getAvatars();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void updateFilter({String? gender, String? age, String? pose}) {
    String? _updateValue(String? currentValue, String? newValue) {
      if (newValue == '') return null;
      return newValue ?? currentValue;
    }

    _filters.gender = _updateValue(_filters.gender, gender);
    _filters.age = _updateValue(_filters.age, age);
    _filters.pose = _updateValue(_filters.pose, pose);

    _applyFilters();
  }

  void resetFilters() {
    _filters.clear();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredAvatars = _allAvatars.where((avatar) {
      final genderMatch =
          _filters.gender == null || avatar.gender == _filters.gender;
      final ageMatch =
          _filters.age == null || _getAgeGroup(avatar.age) == _filters.age;
      final poseMatch = _filters.pose == null || avatar.pose == _filters.pose;
      return genderMatch && ageMatch && poseMatch;
    }).toList();
    notifyListeners();
  }

  String _getAgeGroup(int age) {
    if (age >= 18 && age <= 25) return 'Young adults';
    if (age > 25 && age <= 40) return 'Adults';
    if (age > 40 && age <= 55) return 'Middle-aged';
    return 'Older adults';
  }
}
