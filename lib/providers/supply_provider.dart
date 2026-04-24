import 'package:flutter/material.dart';
import '../models/supply.dart';
import '../services/api_service.dart';

class SupplyProvider extends ChangeNotifier {
  List<Supply> _supplies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedFilter = 'all';

  // Геттеры
  List<Supply> get supplies {
    return _supplies.where((supply) {
      final matchesSearch = supply.productName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          supply.supplier.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'all' || supply.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  int get totalCount => _supplies.length;
  int get filteredCount => supplies.length;

  // ЗАГРУЗКА ДАННЫХ
  Future<void> loadSupplies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _supplies = await ApiService.fetchSupplies();
    } catch (e) {
      _errorMessage = e.toString();
      _supplies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ОБНОВЛЕНИЕ (REFRESH)
  Future<void> refreshSupplies() async {
    await loadSupplies();
  }

  // ДОБАВЛЕНИЕ
  Future<bool> addSupply(Supply supply) async {
    try {
      final newSupply = await ApiService.addSupply(supply);
      _supplies.add(newSupply);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // УДАЛЕНИЕ
  void deleteSupply(String id) {
    _supplies.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ОБНОВЛЕНИЕ ПОСТАВКИ (РЕДАКТИРОВАНИЕ) ← ДОБАВЛЯЕМ ЭТОТ МЕТОД
  void updateSupply(Supply updatedSupply) {
    final index = _supplies.indexWhere((s) => s.id == updatedSupply.id);
    if (index != -1) {
      _supplies[index] = updatedSupply;
      notifyListeners();
    }
  }

  // ПОИСК
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ФИЛЬТР
  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // АУТЕНТИФИКАЦИЯ
  bool login(String username, String password) {
    return username == 'user' && password == '123';
  }
}