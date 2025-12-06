import 'dart:async';

import 'package:avatar_filter_app/domain/entities/avatar.dart';
import 'package:avatar_filter_app/domain/usecases/get_avatars.dart';
import 'package:avatar_filter_app/presentation/providers/avatar_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'avatar_provider_test.mocks.dart';

@GenerateMocks([GetAvatars])
void main() {
  late MockGetAvatars mockGetAvatars;
  late AvatarProvider avatarProvider;
  late Completer<List<Avatar>> getAvatarsCompleter;

  const testAvatars = [
    Avatar(
        id: '1',
        name: 'Liam',
        imageUrl: '',
        age: 22,
        gender: 'Male',
        pose: 'Yoga'),
    Avatar(
        id: '2',
        name: 'Olivia',
        imageUrl: '',
        age: 35,
        gender: 'Female',
        pose: 'Running'),
    Avatar(
        id: '3',
        name: 'Noah',
        imageUrl: '',
        age: 50,
        gender: 'Male',
        pose: 'Gaming'),
  ];

  setUp(() {
    mockGetAvatars = MockGetAvatars();
    getAvatarsCompleter = Completer<List<Avatar>>();
    when(mockGetAvatars.call()).thenAnswer((_) => getAvatarsCompleter.future);

    avatarProvider = AvatarProvider(mockGetAvatars);
  });

  test('Initial state is correct and isLoading is true before future completes',
      () {
    verify(mockGetAvatars.call()).called(1);
    expect(avatarProvider.isLoading, isTrue);
    expect(avatarProvider.filteredAvatars, isEmpty);
  });

  test('State is correct after future completes successfully', () async {
    getAvatarsCompleter.complete(testAvatars);
    await Future.delayed(Duration.zero);

    expect(avatarProvider.isLoading, isFalse);
    expect(avatarProvider.filteredAvatars.length, 3);
    expect(avatarProvider.filteredAvatarsCount, 3);
  });

  test('updateFilter correctly filters the list', () async {
    getAvatarsCompleter.complete(testAvatars);
    await Future.delayed(Duration.zero);

    avatarProvider.updateFilter(gender: 'Female');

    expect(avatarProvider.filteredAvatars.length, 1);
    expect(avatarProvider.filteredAvatars.first.name, 'Olivia');
    expect(avatarProvider.filteredAvatarsCount, 1);
  });

  test('resetFilters clears all filters', () async {
    getAvatarsCompleter.complete(testAvatars);
    await Future.delayed(Duration.zero);
    avatarProvider.updateFilter(gender: 'Female');
    expect(avatarProvider.filteredAvatars.length, 1);

    avatarProvider.resetFilters();

    expect(avatarProvider.filteredAvatars.length, 3);
    expect(avatarProvider.filteredAvatarsCount, 3);
    expect(avatarProvider.filters.isAnyFilterActive, isFalse);
  });
}
