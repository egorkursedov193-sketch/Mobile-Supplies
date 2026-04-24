import '../models/supply.dart';

class ApiService {
  // Просто возвращаем тестовые данные, без реальных HTTP-запросов
  static Future<List<Supply>> fetchSupplies() async {
    // Имитация задержки сети (чтобы показать индикатор загрузки)
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Supply(
        id: '1',
        productName: 'Ноутбук Lenovo ThinkPad',
        quantity: 10,
        price: 45000,
        supplier: 'ООО "Компьютерный мир"',
        deliveryDate: DateTime(2024, 3, 15),
        status: 'pending',
      ),
      Supply(
        id: '2',
        productName: 'Монитор Samsung 24"',
        quantity: 15,
        price: 12000,
        supplier: 'ЗАО "Электроника"',
        deliveryDate: DateTime(2024, 3, 10),
        status: 'delivered',
      ),
      Supply(
        id: '3',
        productName: 'Клавиатура Logitech',
        quantity: 50,
        price: 2500,
        supplier: 'ООО "Компьютерный мир"',
        deliveryDate: DateTime(2024, 3, 5),
        status: 'cancelled',
      ),
      Supply(
        id: '4',
        productName: 'Мышь беспроводная',
        quantity: 30,
        price: 1500,
        supplier: 'ИП "ТехноСнаб"',
        deliveryDate: DateTime(2024, 3, 20),
        status: 'pending',
      ),
    ];
  }
  
  // Добавление через Mock
  static Future<Supply> addSupply(Supply supply) async {
    await Future.delayed(const Duration(seconds: 1));
    return supply.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
  }
}