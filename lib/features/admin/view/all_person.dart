import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/circular_progress.dart';
import 'package:delivery_app/core/widgets/CustomSearchField.dart';
import 'package:delivery_app/features/admin/view/details_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../model/getNameUser.dart';

enum SortOption { alphabetical, newest, rating, sponsorship }
enum FilterStatus { all, active, inactive }

class AllPerson extends StatefulWidget {
  const AllPerson({super.key, required this.role});

  final String role;

  @override
  State<AllPerson> createState() => _AllPersonState();
}

class _AllPersonState extends State<AllPerson> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  SortOption selectedSort = SortOption.newest;
  FilterStatus selectedStatus = FilterStatus.all;
  String selectedLocation = 'كل المناطق';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<GetNameUser> _getFilteredAndSortedList(List<GetNameUser> originalList) {
    // 1. Filter by Search Query
    Iterable<GetNameUser> list = originalList;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      list = list.where((user) =>
          user.name.toLowerCase().contains(query) ||
          user.phone.contains(query));
    }

    // 2. Filter by Status
    if (selectedStatus == FilterStatus.active) {
      list = list.where((user) => user.isActive);
    } else if (selectedStatus == FilterStatus.inactive) {
      list = list.where((user) => !user.isActive);
    }

    // 3. Filter by Location
    if (selectedLocation != 'كل المناطق') {
      list = list.where((user) => user.location.trim() == selectedLocation);
    }

    // 4. Sort
    final sortedList = list.toList();
    switch (selectedSort) {
      case SortOption.alphabetical:
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.newest:
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.rating:
        sortedList.sort((a, b) {
          final ratingA = a.ratingAverage ?? 0.0;
          final ratingB = b.ratingAverage ?? 0.0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case SortOption.sponsorship:
        sortedList.sort((a, b) => b.sponsorshipAmount.compareTo(a.sponsorshipAmount));
        break;
    }

    return sortedList;
  }

  Widget _buildFilterSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildSortChips(String role) {
    final isVendorOrDelivery = role.toLowerCase() == 'vendor' || role.toLowerCase() == 'delivery';
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          _buildChip(
            label: 'الأحدث انضماماً',
            isSelected: selectedSort == SortOption.newest,
            onSelected: () => setState(() => selectedSort = SortOption.newest),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'الاسم أ-ي',
            isSelected: selectedSort == SortOption.alphabetical,
            onSelected: () => setState(() => selectedSort = SortOption.alphabetical),
          ),
          if (isVendorOrDelivery) ...[
            const SizedBox(width: 8),
            _buildChip(
              label: 'الأعلى تقييماً',
              isSelected: selectedSort == SortOption.rating,
              onSelected: () => setState(() => selectedSort = SortOption.rating),
            ),
            const SizedBox(width: 8),
            _buildChip(
              label: 'الأعلى كفالة',
              isSelected: selectedSort == SortOption.sponsorship,
              onSelected: () => setState(() => selectedSort = SortOption.sponsorship),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          _buildChip(
            label: 'الكل',
            isSelected: selectedStatus == FilterStatus.all,
            onSelected: () => setState(() => selectedStatus = FilterStatus.all),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'نشط',
            isSelected: selectedStatus == FilterStatus.active,
            onSelected: () => setState(() => selectedStatus = FilterStatus.active),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'غير نشط',
            isSelected: selectedStatus == FilterStatus.inactive,
            onSelected: () => setState(() => selectedStatus = FilterStatus.inactive),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChips(List<GetNameUser> originalList) {
    final uniqueLocations = originalList
        .map((e) => e.location.trim())
        .where((loc) => loc.isNotEmpty)
        .toSet()
        .toList();

    if (uniqueLocations.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          _buildChip(
            label: 'كل المناطق',
            isSelected: selectedLocation == 'كل المناطق',
            onSelected: () => setState(() => selectedLocation = 'كل المناطق'),
          ),
          for (final loc in uniqueLocations) ...[
            const SizedBox(width: 8),
            _buildChip(
              label: loc,
              isSelected: selectedLocation == loc,
              onSelected: () => setState(() => selectedLocation = loc),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(GetNameUser user) {
    if (user.role.toLowerCase() == 'vendor' && user.images.isNotEmpty && user.images[0].isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          user.images[0],
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/fluent_person-16-filled.png',
              width: 36,
              height: 36,
            );
          },
        ),
      );
    }
    return Image.asset(
      'assets/images/fluent_person-16-filled.png',
      width: 36,
      height: 36,
    );
  }

  Widget _buildUserCard(GetNameUser user, int index) {
    final roleLower = user.role.toLowerCase();
    bool hasRating = (roleLower == 'vendor' || roleLower == 'delivery') &&
        user.ratingAverage != null &&
        user.ratingAverage! > 0;

    String? subtitle;
    Widget? statusIndicator;

    if (roleLower == 'delivery') {
      final sponsorshipText = user.sponsorshipAmount > 0 
          ? ' | كفالة: ${user.sponsorshipAmount} د.ع' 
          : '';
      subtitle = '${user.phone}$sponsorshipText';
      
      statusIndicator = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: user.isActive ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
        ),
      );
    } else if (roleLower == 'vendor') {
      subtitle = '${user.location} | ${user.phone}';
    } else if (roleLower == 'only') {
      subtitle = '${user.location} | ${user.phone}';
    } else {
      subtitle = user.phone;
      statusIndicator = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: user.isActive ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Avatar + Rating + Status Dot
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildAvatar(user),
                  if (statusIndicator != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: statusIndicator,
                      ),
                    ),
                ],
              ),
              if (hasRating) ...[
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      user.ratingAverage!.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    if (user.ratingCount != null && user.ratingCount! > 0)
                      Text(
                        ' (${user.ratingCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
          // Middle: Name and details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right: Index number
          Text(
            ' ${index + 1} #',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (BuildContext context) =>
              AdminCubit()..getNameUser(context: context, role: widget.role),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateBack(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Icon(Icons.arrow_back_ios_new),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'شركة المسار',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Text(
                                  'للتوصيل الداخلي السريع',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 46, height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomSearchField(
                        controller: searchController,
                        hintText: 'ابحث بالاسم أو الهاتف...',
                        onClear: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ConditionalBuilder(
                        condition: cubit.getNameUserModel != null,
                        builder: (c) {
                          final filteredList = _getFilteredAndSortedList(cubit.getNameUserModel!);
                          return Column(
                            children: [
                              _buildFilterSectionTitle('الترتيب حسب:'),
                              _buildSortChips(widget.role),
                              const SizedBox(height: 8),
                              _buildFilterSectionTitle('الحالة:'),
                              _buildStatusChips(),
                              if (cubit.getNameUserModel!.any((e) => e.location.trim().isNotEmpty)) ...[
                                const SizedBox(height: 8),
                                _buildFilterSectionTitle('الموقع/المنطقة:'),
                                _buildLocationChips(cubit.getNameUserModel!),
                              ],
                              const SizedBox(height: 20),
                              if (filteredList.isEmpty) ...[
                                const SizedBox(height: 80),
                                Center(
                                  child: Text(
                                    searchQuery.isEmpty
                                        ? 'لا يوجد بيانات ليتم عرضها'
                                        : 'لا توجد نتائج تطابق خيارات التصفية والبحث',
                                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ] else
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final user = filteredList[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            String image;
                                            if (user.role.toLowerCase() == 'vendor') {
                                              image = user.images.isNotEmpty ? user.images[0] : '';
                                            } else {
                                              image = '';
                                            }
                                            navigateTo(
                                              context,
                                              DetailsPerson(
                                                id: user.id.toString(),
                                                name: user.name,
                                                phone: user.phone,
                                                location: user.location,
                                                role: user.role,
                                                createdAt: user.createdAt.toString(),
                                                sponsorshipAmount: user.sponsorshipAmount.toString(),
                                                image: image,
                                                ratingAverage: user.ratingAverage,
                                                ratingCount: user.ratingCount,
                                              ),
                                            );
                                          },
                                          child: _buildUserCard(user, index),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          );
                        },
                        fallback: (c) => const Center(child: CircularProgress()),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
