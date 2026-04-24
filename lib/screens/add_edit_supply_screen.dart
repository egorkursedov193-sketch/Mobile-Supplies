import 'package:flutter/material.dart';
import '../models/supply.dart';

class AddEditSupplyScreen extends StatefulWidget {
  final Supply? existingSupply;

  const AddEditSupplyScreen({super.key, this.existingSupply});

  @override
  State<AddEditSupplyScreen> createState() => _AddEditSupplyScreenState();
}

class _AddEditSupplyScreenState extends State<AddEditSupplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _supplierController = TextEditingController();
  late DateTime _selectedDate;
  late String _selectedStatus;

  bool get isEditing => widget.existingSupply != null;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  void initState() {
    super.initState();
    
    if (isEditing) {
      final supply = widget.existingSupply!;
      _productNameController.text = supply.productName;
      _quantityController.text = supply.quantity.toString();
      _priceController.text = supply.price.toString();
      _supplierController.text = supply.supplier;
      _selectedDate = supply.deliveryDate;
      _selectedStatus = supply.status;
    } else {
      _selectedDate = DateTime.now();
      _selectedStatus = 'pending';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveSupply() {
    if (_formKey.currentState!.validate()) {
      final supply = Supply(
        id: isEditing ? widget.existingSupply!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        productName: _productNameController.text,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        supplier: _supplierController.text,
        deliveryDate: _selectedDate,
        status: _selectedStatus,
      );
      
      // Возвращаем результат на предыдущий экран
      Navigator.pop(context, {
        'supply': supply,
        'isEditing': isEditing,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать поставку' : 'Добавить поставку'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Название товара', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Количество', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Введите количество';
                        if (int.tryParse(v) == null) return 'Введите число';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Цена за шт.', border: OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Введите цену';
                        if (double.tryParse(v) == null) return 'Введите число';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: 'Поставщик', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Введите поставщика' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Дата поставки', border: OutlineInputBorder()),
                  child: Text(_formatDate(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Статус', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Ожидает')),
                  DropdownMenuItem(value: 'delivered', child: Text('Доставлено')),
                  DropdownMenuItem(value: 'cancelled', child: Text('Отменено')),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSupply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEditing ? 'Обновить' : 'Сохранить', style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _supplierController.dispose();
    super.dispose();
  }
}