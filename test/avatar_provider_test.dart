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
    avatarProvider = AvatarProvider(mockGetAvatars);
    when(mockGetAvatars.call()).thenAnswer((_) async => testAvatars);
  });

  test('Initial state is correct', () {
    expect(avatarProvider.isLoading, isTrue);
    expect(avatarProvider.filteredAvatars, isEmpty);
  });

  test('fetchAvatars calls GetAvatars usecase and updates state', () async {
    // Act
    await avatarProvider.fetchAvatars();
    // Assert
    verify(mockGetAvatars.call()).called(1);
    expect(avatarProvider.isLoading, isFalse);
    expect(avatarProvider.filteredAvatars.length, 3);
  });

  test('updateFilter correctly filters by age group', () async {
    await avatarProvider.fetchAvatars();
    avatarProvider.updateFilter(age: 'Young adults');
    expect(avatarProvider.filteredAvatars.length, 1);
    expect(avatarProvider.filteredAvatars.first.name, 'Liam');
  });

  test('updateFilter correctly filters by gender', () async {
    await avatarProvider.fetchAvatars();
    avatarProvider.updateFilter(gender: 'Female');
    expect(avatarProvider.filteredAvatars.length, 1);
    expect(avatarProvider.filteredAvatars.first.name, 'Olivia');
  });

  test('resetFilters clears all filters and shows all avatars', () async {
    await avatarProvider.fetchAvatars();
    avatarProvider.updateFilter(gender: 'Female');
    expect(avatarProvider.filteredAvatars.length, 1);

    avatarProvider.resetFilters();
    expect(avatarProvider.filteredAvatars.length, 3);
    expect(avatarProvider.filters.isAnyFilterActive, isFalse);
  });

  test('updateFilter with "All" value removes the filter', () async {
    await avatarProvider.fetchAvatars();
    avatarProvider.updateFilter(gender: 'Female');
    expect(avatarProvider.filteredAvatars.length, 1);
    avatarProvider.updateFilter(gender: 'All');
    expect(avatarProvider.filteredAvatars.length, 3);
    expect(avatarProvider.filters.gender, isNull);
  });
}
