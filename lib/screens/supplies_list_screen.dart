import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supply_provider.dart';
import '../widgets/supply_card.dart';
import 'add_edit_supply_screen.dart';
import 'supply_details_screen.dart';
import '../models/supply.dart';

class SuppliesListScreen extends StatefulWidget {
  const SuppliesListScreen({super.key});

  @override
  State<SuppliesListScreen> createState() => _SuppliesListScreenState();
}

class _SuppliesListScreenState extends State<SuppliesListScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplyProvider>(context, listen: false).loadSupplies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои поставки'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Кнопка обновления
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<SupplyProvider>(context, listen: false).refreshSupplies();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Consumer<SupplyProvider>(
        builder: (context, provider, child) {
          // ИНДИКАТОР ЗАГРУЗКИ
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загрузка данных...'),
                ],
              ),
            );
          }

          // ОБРАБОТКА ОШИБОК
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Ошибка: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSupplies(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          // ОСНОВНОЙ КОНТЕНТ (если данные загружены)
          return RefreshIndicator(
            onRefresh: () => provider.refreshSupplies(),
            child: Column(
              children: [
                // Приветствие со статистикой
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Учёт поставок',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Всего: ${provider.totalCount} | Показано: ${provider.filteredCount}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Поле поиска
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию или поставщику...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onChanged: (value) => provider.setSearchQuery(value),
                  ),
                ),
                
                // Фильтры по статусу (ChoiceChip для телефона)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Все
                        ChoiceChip(
                          label: const Text('Все'),
                          selected: provider.selectedFilter == 'all',
                          onSelected: (selected) {
                            if (selected) provider.setSelectedFilter('all');
                          },
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: provider.selectedFilter == 'all' ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Ожидает
                        ChoiceChip(
                          label: const Text('Ожидает'),
                          selected: provider.selectedFilter == 'pending',
                          onSelected: (selected) {
                            if (selected) provider.setSelectedFilter('pending');
                          },
                          selectedColor: Colors.orange,
                          labelStyle: TextStyle(
                            color: provider.selectedFilter == 'pending' ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Доставлено
                        ChoiceChip(
                          label: const Text('Доставлено'),
                          selected: provider.selectedFilter == 'delivered',
                          onSelected: (selected) {
                            if (selected) provider.setSelectedFilter('delivered');
                          },
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(
                            color: provider.selectedFilter == 'delivered' ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Отменено
                        ChoiceChip(
                          label: const Text('Отменено'),
                          selected: provider.selectedFilter == 'cancelled',
                          onSelected: (selected) {
                            if (selected) provider.setSelectedFilter('cancelled');
                          },
                          selectedColor: Colors.red,
                          labelStyle: TextStyle(
                            color: provider.selectedFilter == 'cancelled' ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Список поставок
                Expanded(
                  child: provider.supplies.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Нет поставок', style: TextStyle(fontSize: 18, color: Colors.grey)),
                              SizedBox(height: 8),
                              Text('Нажмите + чтобы добавить поставку'),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.supplies.length,
                          itemBuilder: (context, index) {
                            final supply = provider.supplies[index];
                            return SupplyCard(
                              supply: supply,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SupplyDetailsScreen(supply: supply),
                                  ),
                                );
                              },
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditSupplyScreen(existingSupply: supply),
                                  ),
                                );
                                if (result != null && result['isEditing'] == true) {
                                  provider.updateSupply(result['supply'] as Supply);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Поставка обновлена!'), backgroundColor: Colors.green),
                                  );
                                }
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Удалить поставку?'),
                                    content: Text('Вы уверены, что хотите удалить "${supply.productName}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Отмена'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          provider.deleteSupply(supply.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('"${supply.productName}" удалена')),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditSupplyScreen()),
          );
          if (result != null && result['isEditing'] == false) {
            final provider = Provider.of<SupplyProvider>(context, listen: false);
            provider.addSupply(result['supply'] as Supply);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Поставка добавлена!'), backgroundColor: Colors.green),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить поставку'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}