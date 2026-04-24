import 'package:flutter/material.dart';
import '../models/supply.dart';

class SupplyDetailsScreen extends StatelessWidget {
  final Supply supply;

  const SupplyDetailsScreen({super.key, required this.supply});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'Ожидает';
      case 'delivered': return 'Доставлено';
      case 'cancelled': return 'Отменено';
      default: return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supply.productName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(supply.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(supply.status),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getStatusColor(supply.status)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildDetailRow(Icons.shopping_cart, 'Название товара', supply.productName),
                const Divider(),
                _buildDetailRow(Icons.numbers, 'Количество', '${supply.quantity} шт.'),
                const Divider(),
                _buildDetailRow(Icons.attach_money, 'Цена за единицу', '${supply.price.toStringAsFixed(2)} ₽'),
                const Divider(),
                _buildDetailRow(Icons.calculate, 'Общая стоимость', '${supply.totalPrice.toStringAsFixed(2)} ₽', isTotal: true),
                const Divider(),
                _buildDetailRow(Icons.business, 'Поставщик', supply.supplier),
                const Divider(),
                _buildDetailRow(Icons.calendar_today, 'Дата поставки', _formatDate(supply.deliveryDate)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blue.shade700),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTotal ? 24 : 18,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: isTotal ? Colors.blue.shade700 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}