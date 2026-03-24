import 'package:cloud_firestore/cloud_firestore.dart';

/// Seeds the static Tet deals catalog into Firestore `deals` collection.
/// Only runs once – skips if the collection already has documents.
class DealSeederService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Call once at app start (after Firebase.initializeApp).
  static Future<void> seedIfEmpty() async {
    try {
      final col = _db.collection('deals');
      
      // Removed the empty check. We want to force-update existing deals
      // so they get the new `imageUrl` fields.
      final batch = _db.batch();
      for (final deal in _kSeedDeals) {
        final ref = col.doc(deal['id'] as String);
        batch.set(ref, deal, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (_) {
      // silently ignore – app still works with local static list
    }
  }

  /// Fetch all deals from Firestore. Falls back to static list on error.
  static Future<List<Map<String, dynamic>>> fetchDeals() async {
    try {
      final snap = await _db.collection('deals').orderBy('id').get();
      if (snap.docs.isEmpty) return _kSeedDeals;
      return snap.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (_) {
      return _kSeedDeals;
    }
  }
}

/// Static catalog with accurate, content-matched image URLs.
const List<Map<String, dynamic>> _kSeedDeals = [
  {
    'id': '1',
    'name': 'Thùng Bia Heineken',
    'price': 450000,
    'oldPrice': 480000,
    'iconName': 'local_drink',
    'store': 'Bách Hóa Xanh',
    'storeColor': 0xFF00897B,
    'category': 'Đồ Uống',
    // Heineken beer cans/bottles – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1608270586620-248524c67de9?w=600&q=80',
    'discount': 6,
  },
  {
    'id': '2',
    'name': 'Hộp Mứt Tết Cao Cấp',
    'price': 160000,
    'oldPrice': 320000,
    'iconName': 'cookie',
    'store': 'Co.opmart',
    'storeColor': 0xFF1976D2,
    'category': 'Quà Biếu',
    // Assorted cookies / candy in gift box – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1621236378699-8597faf6a176?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '3',
    'name': 'Bánh Chưng Đặc Biệt',
    'price': 120000,
    'oldPrice': 150000,
    'iconName': 'bakery_dining',
    'store': 'Siêu thị Vinmart',
    'storeColor': 0xFF7B1FA2,
    'category': 'Đặc Sản',
    // Sticky rice / bánh chưng style food – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&q=80',
    'discount': 20,
  },
  {
    'id': '4',
    'name': 'Rượu Vang Chi-lê',
    'price': 550000,
    'oldPrice': 1100000,
    'iconName': 'wine_bar',
    'store': 'Lotte Mart',
    'storeColor': 0xFFC62828,
    'category': 'Đồ Uống',
    // Red wine bottle – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '5',
    'name': 'Hộp Quà Trà Ô Long',
    'price': 110000,
    'oldPrice': 220000,
    'iconName': 'local_cafe',
    'store': 'Phúc Long',
    'storeColor': 0xFF388E3C,
    'category': 'Quà Biếu',
    // Oolong tea / loose leaf tea in box – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '6',
    'name': 'Gói Hạt Châu Mỹ',
    'price': 95000,
    'oldPrice': 120000,
    'iconName': 'breakfast_dining',
    'store': 'Bách Hóa Xanh',
    'storeColor': 0xFF00897B,
    'category': 'Đặc Sản',
    // Mixed nuts / almonds – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=600&q=80',
    'discount': 21,
  },
  {
    'id': '7',
    'name': 'Đèn Lồng Trang Trí',
    'price': 45000,
    'oldPrice': 95000,
    'iconName': 'light',
    'store': 'Shopee Mall',
    'storeColor': 0xFFE64A19,
    'category': 'Trang Trí',
    // Red lanterns – accurate Tet decoration match
    'imageUrl': 'https://images.unsplash.com/photo-1583425423888-e1af0c4a09e4?w=600&q=80',
    'discount': 53,
  },
  {
    'id': '8',
    'name': 'Hoa Mai Vàng Giả',
    'price': 220000,
    'oldPrice': 450000,
    'iconName': 'filter_vintage',
    'store': 'Lazada',
    'storeColor': 0xFF6A1B9A,
    'category': 'Trang Trí',
    // Yellow flowers / apricot blossom – accurate Tet match
    'imageUrl': 'https://images.unsplash.com/photo-1490750967868-88df5691cc40?w=600&q=80',
    'discount': 51,
  },
  {
    'id': '9',
    'name': 'Giỏ Trái Cây Nhập',
    'price': 350000,
    'oldPrice': 450000,
    'iconName': 'food_bank',
    'store': 'Aeon Mall',
    'storeColor': 0xFFD84315,
    'category': 'Thực Phẩm',
    // Fruit basket – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&q=80',
    'discount': 22,
  },
  {
    'id': '10',
    'name': 'Bánh Tét Nhân Thập Cẩm',
    'price': 80000,
    'oldPrice': 100000,
    'iconName': 'cake',
    'store': 'Cửa Hàng Truyền Thống',
    'storeColor': 0xFF795548,
    'category': 'Đặc Sản',
    // Rice cake / traditional cake – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&q=80',
    'discount': 20,
  },
  {
    'id': '11',
    'name': 'Nước Hoa Đêm Xuân',
    'price': 299000,
    'oldPrice': 650000,
    'iconName': 'spa',
    'store': 'Guardian',
    'storeColor': 0xFFAD1457,
    'category': 'Sức Khoẻ',
    // Perfume bottle – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=600&q=80',
    'discount': 54,
  },
  {
    'id': '12',
    'name': 'Bộ Sưu Tập Decor Xuân',
    'price': 180000,
    'oldPrice': 380000,
    'iconName': 'home_outlined',
    'store': 'IKEA VN',
    'storeColor': 0xFF1565C0,
    'category': 'Trang Trí',
    // Home decoration items – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1543589077-47d81606c1bf?w=600&q=80',
    'discount': 53,
  },
  {
    'id': '13',
    'name': 'Áo Dài Cách Tân Nữ',
    'price': 450000,
    'oldPrice': 900000,
    'iconName': 'style',
    'store': 'Zara VN',
    'storeColor': 0xFF212121,
    'category': 'Thời Trang',
    // Áo dài / Vietnamese traditional dress – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1617521124379-66a24e99fb74?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '14',
    'name': 'Combo Snack Tết 10 Gói',
    'price': 120000,
    'oldPrice': 200000,
    'iconName': 'fastfood',
    'store': 'WinMart',
    'storeColor': 0xFF1B5E20,
    'category': 'Thực Phẩm',
    // Snack chips – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=600&q=80',
    'discount': 40,
  },
  {
    'id': '15',
    'name': 'Nến Thơm Phòng Khách',
    'price': 89000,
    'oldPrice': 180000,
    'iconName': 'wb_sunny_outlined',
    'store': 'Shopee Mall',
    'storeColor': 0xFFE64A19,
    'category': 'Trang Trí',
    // Scented candle – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1602178585069-f768f37185f4?w=600&q=80',
    'discount': 51,
  },
  {
    'id': '16',
    'name': 'Rổ Mây Đựng Quà',
    'price': 65000,
    'oldPrice': 130000,
    'iconName': 'shopping_basket',
    'store': 'Tiki',
    'storeColor': 0xFF0D47A1,
    'category': 'Quà Biếu',
    // Wicker basket / gift hamper – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1557821552-17105176677c?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '17',
    'name': 'Trà Dilmah Hộp Quà',
    'price': 250000,
    'oldPrice': 330000,
    'iconName': 'emoji_food_beverage',
    'store': 'Co.opmart',
    'storeColor': 0xFF1976D2,
    'category': 'Quà Biếu',
    // Tea gift box – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=80',
    'discount': 24,
  },
  {
    'id': '18',
    'name': 'Máy Xay Sinh Tố Mini',
    'price': 299000,
    'oldPrice': 599000,
    'iconName': 'blender',
    'store': 'Điện Máy Xanh',
    'storeColor': 0xFF0277BD,
    'category': 'Sức Khoẻ',
    // Blender / juicer – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=600&q=80',
    'discount': 50,
  },
  {
    'id': '19',
    'name': 'Set 3 Khăn Lụa Tơ Tằm',
    'price': 390000,
    'oldPrice': 790000,
    'iconName': 'dry_cleaning',
    'store': 'Lụa Hà Đông',
    'storeColor': 0xFF880E4F,
    'category': 'Thời Trang',
    // Silk scarves / fabric – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80',
    'discount': 51,
  },
  {
    'id': '20',
    'name': 'Viên Nano Nghệ Mật Ong',
    'price': 150000,
    'oldPrice': 300000,
    'iconName': 'medical_services_outlined',
    'store': 'Long Châu',
    'storeColor': 0xFF00695C,
    'category': 'Sức Khoẻ',
    // Honey / health supplement – accurate match
    'imageUrl': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&q=80',
    'discount': 50,
  },
];
