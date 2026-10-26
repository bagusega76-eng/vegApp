class VegetableCategory {
  final String slug;
  final String nama;
  final int jumlah;

  const VegetableCategory({
    required this.slug,
    required this.nama,
    required this.jumlah,
  });

  factory VegetableCategory.fromJson(Map<String, dynamic> json) {
    return VegetableCategory(
      slug: json['slug']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      jumlah: json['jumlah'] is int
          ? json['jumlah'] as int
          : int.tryParse(json['jumlah']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'nama': nama,
      'jumlah': jumlah,
    };
  }
}
