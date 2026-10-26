class VegetableModel {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final double price;
  final double? originalPrice;
  final String unit;
  final double rating;
  final int reviewsCount;
  final String imagePath;
  final String description;
  final String origin;
  final List<String> benefits;
  final String calories;
  final String fiber;
  final String? carbs;
  final String? protein;
  final String waterContent;
  final String? storageTips;
  final bool isOrganic;
  final bool isBestSeller;

  const VegetableModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.unit,
    required this.rating,
    required this.reviewsCount,
    required this.imagePath,
    required this.description,
    required this.origin,
    required this.benefits,
    required this.calories,
    required this.fiber,
    this.carbs,
    this.protein,
    required this.waterContent,
    this.storageTips,
    this.isOrganic = true,
    this.isBestSeller = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  factory VegetableModel.fromJson(Map<String, dynamic> json) {
    final nutrisi = json['nutrisi'] is Map ? (json['nutrisi'] as Map) : null;

    final benefitsList = json['manfaat'] is List
        ? (json['manfaat'] as List).map((e) => e.toString()).toList()
        : (json['benefits'] is List
            ? (json['benefits'] as List).map((e) => e.toString()).toList()
            : <String>['100% Segar', 'Kualitas Pilihan', 'Bebas Kimia Berlebih']);

    final rawPrice = json['harga'] ?? json['price'] ?? 0;
    final price = rawPrice is num ? rawPrice.toDouble() : double.tryParse(rawPrice.toString()) ?? 0.0;

    final rawOrig = json['originalPrice'] ?? (price > 0 ? (price * 1.2).roundToDouble() : null);
    final origPrice = rawOrig is num ? rawOrig.toDouble() : double.tryParse(rawOrig?.toString() ?? '');

    return VegetableModel(
      id: (json['id'] ?? '').toString(),
      name: json['nama']?.toString() ?? json['name']?.toString() ?? 'Sayur Segar',
      scientificName: json['scientificName']?.toString() ?? '',
      category: json['kategori']?.toString() ?? json['category']?.toString() ?? 'Sayuran',
      price: price,
      originalPrice: origPrice,
      unit: json['unit']?.toString() ?? '500g',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 4.8,
      reviewsCount: json['reviewsCount'] != null ? (json['reviewsCount'] as num).toInt() : 84,
      imagePath: json['gambar']?.toString() ?? json['imagePath']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? json['description']?.toString() ?? '',
      origin: json['asal']?.toString() ?? json['origin']?.toString() ?? 'Petani Lokal',
      benefits: benefitsList,
      calories: nutrisi?['kalori']?.toString() ?? json['calories']?.toString() ?? '25 kkal / 100g',
      fiber: nutrisi?['serat']?.toString() ?? json['fiber']?.toString() ?? '2.0g',
      carbs: nutrisi?['karbohidrat']?.toString() ?? json['carbs']?.toString() ?? '3.5g',
      protein: nutrisi?['protein']?.toString() ?? json['protein']?.toString() ?? '2.1g',
      waterContent: json['waterContent']?.toString() ?? '92%',
      storageTips: json['tipsPenyimpanan']?.toString() ?? json['storageTips']?.toString(),
      isOrganic: json['isOrganic'] == true || (json['isOrganic'] == null && true),
      isBestSeller: json['isBestSeller'] == true || (json['id'] != null && (json['id'] == 1 || json['id'] == 6 || json['id'] == 10)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'scientificName': scientificName,
      'kategori': category,
      'harga': price,
      'originalPrice': originalPrice,
      'unit': unit,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'gambar': imagePath,
      'deskripsi': description,
      'asal': origin,
      'manfaat': benefits,
      'tipsPenyimpanan': storageTips,
      'nutrisi': {
        'kalori': calories,
        'serat': fiber,
        'karbohidrat': carbs,
        'protein': protein,
      },
      'waterContent': waterContent,
      'isOrganic': isOrganic,
      'isBestSeller': isBestSeller,
    };
  }

  VegetableModel copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? category,
    double? price,
    double? originalPrice,
    String? unit,
    double? rating,
    int? reviewsCount,
    String? imagePath,
    String? description,
    String? origin,
    List<String>? benefits,
    String? calories,
    String? fiber,
    String? carbs,
    String? protein,
    String? waterContent,
    String? storageTips,
    bool? isOrganic,
    bool? isBestSeller,
  }) {
    return VegetableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      unit: unit ?? this.unit,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      benefits: benefits ?? this.benefits,
      calories: calories ?? this.calories,
      fiber: fiber ?? this.fiber,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      waterContent: waterContent ?? this.waterContent,
      storageTips: storageTips ?? this.storageTips,
      isOrganic: isOrganic ?? this.isOrganic,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }
}

// Fallback dummy vegetables data utilizing local assets
final List<VegetableModel> sampleVegetables = [
  const VegetableModel(
    id: '1',
    name: 'Wortel Manis Organik',
    scientificName: 'Daucus carota',
    category: 'Sayuran Umbi',
    price: 8000,
    originalPrice: 10000,
    unit: '500g',
    rating: 4.9,
    reviewsCount: 142,
    imagePath: 'assets/images/carrot.png',
    description:
        'Wortel manis segar hasil panen petani lokal dataran tinggi. Ditanam secara organik tanpa pestisida kimia. Kaya akan beta-karoten, vitamin A, dan antioksidan untuk kesehatan mata dan imunitas tubuh.',
    origin: 'Perkebunan Lembang, Jawa Barat',
    benefits: ['100% Organik', 'Kaya Vitamin A', 'Dipanen Subuh'],
    calories: '41 kkal / 100g',
    fiber: '2.8g',
    carbs: '9.6g',
    protein: '0.9g',
    waterContent: '88%',
    storageTips: 'Simpan di laci kulkas beralas tisu kering untuk kesegaran tahan lama.',
    isOrganic: true,
    isBestSeller: true,
  ),
  const VegetableModel(
    id: '6',
    name: 'Tomat Merah Segar',
    scientificName: 'Solanum lycopersicum',
    category: 'Sayuran Buah',
    price: 7000,
    originalPrice: 9000,
    unit: '500g',
    rating: 4.8,
    reviewsCount: 98,
    imagePath: 'assets/images/tomato.png',
    description:
        'Tomat merah matang pohon kaya likopen, bertekstur padat dengan rasa manis-asam seimbang. Sangat cocok untuk salad segar, tumisan, atau jus sehat keluarga sehari-hari.',
    origin: 'Kebun Hidroponik Batu, Malang',
    benefits: ['Bebas Pestisida', 'Tinggi Likopen', 'Super Segar'],
    calories: '18 kkal / 100g',
    fiber: '1.2g',
    carbs: '3.9g',
    protein: '0.9g',
    waterContent: '94%',
    storageTips: 'Simpan pada suhu ruang berventilasi baik agar aroma tetap terjaga.',
    isOrganic: true,
    isBestSeller: true,
  ),
  const VegetableModel(
    id: '12',
    name: 'Bawang Bombay Emas',
    scientificName: 'Allium cepa',
    category: 'Sayuran Umbi',
    price: 18000,
    originalPrice: 22000,
    unit: '500g',
    rating: 4.7,
    reviewsCount: 76,
    imagePath: 'assets/images/onion.png',
    description:
        'Bawang kualitas unggul dengan lapisan tebal beraroma sedap dan manis saat ditumis. Pilihan utama chef untuk kaldu dan aneka masakan istimewa.',
    origin: 'Brebes, Jawa Tengah',
    benefits: ['Aroma Kuat', 'Pilihan Chef', 'Tahan Lama'],
    calories: '40 kkal / 100g',
    fiber: '1.7g',
    carbs: '9.3g',
    protein: '1.1g',
    waterContent: '89%',
    storageTips: 'Simpan di tempat kering dan sejuk dengan sirkulasi udara baik.',
    isOrganic: true,
    isBestSeller: false,
  ),
  const VegetableModel(
    id: '9',
    name: 'Paprika & Cabai Pilihan',
    scientificName: 'Capsicum annuum',
    category: 'Sayuran Buah',
    price: 12000,
    originalPrice: 15000,
    unit: '250g',
    rating: 4.9,
    reviewsCount: 115,
    imagePath: 'assets/images/pepper.png',
    description:
        'Paprika dan cabai segar kualitas premium dengan tekstur tebal dan sangat renyah. Memiliki kandungan vitamin C tertinggi untuk daya tahan tubuh maksimal.',
    origin: 'Greenhouse Bedugul, Bali',
    benefits: ['Super Vitamin C', 'Segar & Renyah', 'Grade A Ekspor'],
    calories: '31 kkal / 100g',
    fiber: '2.1g',
    carbs: '6.0g',
    protein: '1.0g',
    waterContent: '92%',
    storageTips: 'Bungkus kertas atau simpan dalam kantong berlubang di kulkas.',
    isOrganic: true,
    isBestSeller: true,
  ),
];
