enum OrderStatus {
  inDelivery,
  delivered,
  cancelled,
}

class OrderItemSummary {
  final String name;
  final int qty;
  final String imagePath;
  final double price;

  const OrderItemSummary({
    required this.name,
    required this.qty,
    required this.imagePath,
    required this.price,
  });
}

class OrderModel {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItemSummary> items;
  final String deliveryAddress;

  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.deliveryAddress,
  });

  String get formattedStatus {
    switch (status) {
      case OrderStatus.inDelivery:
        return 'Sedang Dikirim 🛵';
      case OrderStatus.delivered:
        return 'Selesai Diterima ✨';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

final List<OrderModel> sampleOrders = [
  OrderModel(
    id: 'VG-882910',
    date: DateTime.now().subtract(const Duration(minutes: 42)),
    status: OrderStatus.inDelivery,
    totalAmount: 58500,
    deliveryAddress: 'Jl. Surya Kencana No. 45, Kebayoran Baru',
    items: const [
      OrderItemSummary(
        name: 'Wortel Manis Organik',
        qty: 2,
        imagePath: 'assets/images/carrot.png',
        price: 18000,
      ),
      OrderItemSummary(
        name: 'Tomat Ceri Merah Segar',
        qty: 1,
        imagePath: 'assets/images/tomato.png',
        price: 22500,
      ),
    ],
  ),
  OrderModel(
    id: 'VG-774012',
    date: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    status: OrderStatus.delivered,
    totalAmount: 48000,
    deliveryAddress: 'Jl. Surya Kencana No. 45, Kebayoran Baru',
    items: const [
      OrderItemSummary(
        name: 'Paprika Renyah Pilihan',
        qty: 1,
        imagePath: 'assets/images/pepper.png',
        price: 32000,
      ),
      OrderItemSummary(
        name: 'Bawang Bombay Emas',
        qty: 1,
        imagePath: 'assets/images/onion.png',
        price: 16000,
      ),
    ],
  ),
];
