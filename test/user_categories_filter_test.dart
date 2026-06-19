import 'package:flutter_test/flutter_test.dart';
import 'package:delivery_app/features/admin/model/getNameUser.dart';

enum SortOption { alphabetical, newest, rating, sponsorship }
enum FilterStatus { all, active, inactive }

void main() {
  group('User Categories Filtering and Sorting Tests', () {
    final mockUsers = [
      GetNameUser(
        id: 1,
        name: 'أحمد محمود',
        phone: '07701111111',
        location: 'بغداد',
        isActive: true,
        role: 'vendor',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime.now(),
        ratingAverage: 4.8,
        ratingCount: 10,
        sponsorshipAmount: 50000,
      ),
      GetNameUser(
        id: 2,
        name: 'بشير علي',
        phone: '07802222222',
        location: 'البصرة',
        isActive: false,
        role: 'delivery',
        createdAt: DateTime(2026, 2, 1),
        updatedAt: DateTime.now(),
        ratingAverage: 3.5,
        ratingCount: 5,
        sponsorshipAmount: 150000,
      ),
      GetNameUser(
        id: 3,
        name: 'جاسم محمد',
        phone: '07503333333',
        location: 'بغداد',
        isActive: true,
        role: 'Only',
        createdAt: DateTime(2026, 1, 15),
        updatedAt: DateTime.now(),
        ratingAverage: 0.0,
        ratingCount: 0,
        sponsorshipAmount: 0,
      ),
    ];

    List<GetNameUser> getFilteredAndSortedList({
      required List<GetNameUser> originalList,
      required String searchQuery,
      required SortOption selectedSort,
      required FilterStatus selectedStatus,
      required String selectedLocation,
    }) {
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

    test('should search by name', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: 'بشير',
        selectedSort: SortOption.alphabetical,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result.length, 1);
      expect(result.first.name, 'بشير علي');
    });

    test('should search by phone number', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '0770',
        selectedSort: SortOption.alphabetical,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result.length, 1);
      expect(result.first.phone, '07701111111');
    });

    test('should filter by status (active)', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.alphabetical,
        selectedStatus: FilterStatus.active,
        selectedLocation: 'كل المناطق',
      );
      expect(result.length, 2);
      expect(result.any((u) => u.name == 'بشير علي'), isFalse);
    });

    test('should filter by location', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.alphabetical,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'البصرة',
      );
      expect(result.length, 1);
      expect(result.first.name, 'بشير علي');
    });

    test('should sort alphabetically', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.alphabetical,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result[0].name, 'أحمد محمود');
      expect(result[1].name, 'بشير علي');
      expect(result[2].name, 'جاسم محمد');
    });

    test('should sort by newest joined first', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.newest,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result[0].name, 'بشير علي'); // Feb 1
      expect(result[1].name, 'جاسم محمد'); // Jan 15
      expect(result[2].name, 'أحمد محمود'); // Jan 1
    });

    test('should sort by highest rating', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.rating,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result[0].ratingAverage, 4.8);
      expect(result[1].ratingAverage, 3.5);
    });

    test('should sort by highest sponsorship amount', () {
      final result = getFilteredAndSortedList(
        originalList: mockUsers,
        searchQuery: '',
        selectedSort: SortOption.sponsorship,
        selectedStatus: FilterStatus.all,
        selectedLocation: 'كل المناطق',
      );
      expect(result[0].sponsorshipAmount, 150000); // بشير علي
      expect(result[1].sponsorshipAmount, 50000);  // أحمد محمود
      expect(result[2].sponsorshipAmount, 0);        // جاسم محمد
    });
  });
}
