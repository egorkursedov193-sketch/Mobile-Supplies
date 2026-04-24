class Supply {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final String supplier;
  final DateTime deliveryDate;
  final String status;

  Supply({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.supplier,
    required this.deliveryDate,
    required this.status,
  });

  double get totalPrice => quantity * price;

  // Метод copyWith для создания копии с изменёнными полями
  Supply copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? price,
    String? supplier,
    DateTime? deliveryDate,
    String? status,
  }) {
    return Supply(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      supplier: supplier ?? this.supplier,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
    );
  }

  // Преобразование в JSON (для POST запроса)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'supplier': supplier,
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status,
    };
  }

  // Создание из JSON (для GET запроса)
  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json['id'].toString(),
      productName: json['title'] ?? 'Товар ${json['id']}',
      quantity: 10,
      price: 1000.0,
      supplier: 'Поставщик ${json['userId']}',
      deliveryDate: DateTime.now(),
      status: 'pending',
    );
  }
}