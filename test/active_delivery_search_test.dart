import 'package:flutter_test/flutter_test.dart';
import 'package:delivery_app/features/admin/model/GetActiveDeliveryModel.dart';

void main() {
  group('Active Delivery Search Filtering Tests', () {
    final mockDelegates = [
      GetActiveDeliveryModel(
        id: 1,
        name: 'صفاء جاسم حامد',
        phone: '07701234567',
        location: 'Baghdad',
        isActive: true,
        role: 'delivery',
        updatedAt: DateTime.now(),
      ),
      GetActiveDeliveryModel(
        id: 2,
        name: 'احمد محمود لطيف',
        phone: '07809876543',
        location: 'Basra',
        isActive: true,
        role: 'delivery',
        updatedAt: DateTime.now(),
      ),
      GetActiveDeliveryModel(
        id: 3,
        name: 'محمد حميد عبد الله',
        phone: '07505556667',
        location: 'Erbil',
        isActive: true,
        role: 'delivery',
        updatedAt: DateTime.now(),
      ),
    ];

    List<GetActiveDeliveryModel> filterDelegates(
      List<GetActiveDeliveryModel> list,
      String query,
    ) {
      if (query.isEmpty) return list;
      return list.where((element) {
        return element.name.toLowerCase().contains(query.toLowerCase()) ||
            element.phone.contains(query);
      }).toList();
    }

    test('should return all delegates if search query is empty', () {
      final result = filterDelegates(mockDelegates, '');
      expect(result.length, 3);
    });

    test('should filter delegates by name (exact Arabic match)', () {
      final result = filterDelegates(mockDelegates, 'صفاء');
      expect(result.length, 1);
      expect(result.first.name, 'صفاء جاسم حامد');
    });

    test('should filter delegates by name (partial match)', () {
      final result = filterDelegates(mockDelegates, 'محمود');
      expect(result.length, 1);
      expect(result.first.name, 'احمد محمود لطيف');
    });

    test('should filter delegates by phone number', () {
      final result = filterDelegates(mockDelegates, '0780');
      expect(result.length, 1);
      expect(result.first.phone, '07809876543');
    });

    test('should return empty list if no match is found', () {
      final result = filterDelegates(mockDelegates, 'زيد');
      expect(result.isEmpty, true);
    });
  });
}
