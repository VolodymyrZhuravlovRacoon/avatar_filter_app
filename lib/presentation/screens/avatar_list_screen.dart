import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/avatar.dart';
import '../providers/avatar_provider.dart';
import '../widgets/filter_modal_widget.dart';

class AvatarListScreen extends StatelessWidget {
  const AvatarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        body: Column(
          children: [
            _buildFilterBar(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final provider = context.watch<AvatarProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('All avatars',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Visibility(
                visible: provider.filters.isAnyFilterActive,
                child: InkWell(
                  onTap: () {
                    provider.resetFilters();
                  },
                  child: AnimatedContainer(
                      margin: const EdgeInsets.only(right: 8),
                      duration: const Duration(milliseconds: 200),
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 1)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      )),
                ),
              ),
              _buildFilterChip(
                context,
                counts: provider.filteredAvatars.length,
                label: 'Gender',
                value: provider.filters.gender,
                options: ['Male', 'Female'],
                onSave: (selected) => provider.updateFilter(gender: selected),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                counts: provider.filteredAvatars.length,
                label: 'Age',
                value: provider.filters.age,
                options: [
                  'Young adults',
                  'Adults',
                  'Middle-aged',
                  'Older adults'
                ],
                onSave: (selected) => provider.updateFilter(age: selected),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                counts: provider.filteredAvatars.length,
                label: 'Pose',
                value: provider.filters.pose,
                options: [
                  'Standing',
                  'Sitting',
                  'Selfie',
                  'Car selfie',
                  'Walking',
                ],
                onSave: (selected) => provider.updateFilter(pose: selected),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    String? value,
    int? counts,
    required List<String> options,
    required ValueChanged<String?> onSave,
  }) {
    final bool isActive = value != null;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => FilterModalWidget(
            title: label,
            options: options,
            initialValue: value ?? '',
            onSave: onSave,
          ),
        );
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1)),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              Visibility(
                visible: isActive,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    counts.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
              )
            ],
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<AvatarProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        }
        if (provider.filteredAvatars.isEmpty) {
          return _buildEmptyState(provider.resetFilters);
        }
        return _buildAvatarsGrid(context, provider.filteredAvatars);
      },
    );
  }

  Widget _buildAvatarsGrid(BuildContext context, List<Avatar> avatars) {
    return AnimationLimiter(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 3,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: NetworkImage(avatar.imageUrl),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(avatar.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text('${avatar.gender}  •  ${avatar.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(VoidCallback onReset) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_state.png',
              height: 165,
            ),
            const SizedBox(height: 8),
            const Text(
              'Nothing was found using these filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: onReset,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 19),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.grey.shade200, width: 1)),
                child: const Text(
                  'Clear filters',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
