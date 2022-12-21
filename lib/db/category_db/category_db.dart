import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/Category/category_model.dart';

const categoryDbName = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategoris();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteItem(String id);
}

class CategoryDB implements CategoryDbFunctions {
  ValueNotifier<List<CategoryModel>> incomeCagegoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCagegoryListNotifier =
      ValueNotifier([]);

  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await _categoryDB.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<CategoryModel>> getCategoris() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUi() async {
    final _allCategories = await getCategoris();
    incomeCagegoryListNotifier.value.clear();
    expenseCagegoryListNotifier.value.clear();
    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCagegoryListNotifier.value.add(category);
      } else {
        expenseCagegoryListNotifier.value.add(category);
      }
    });
    incomeCagegoryListNotifier.notifyListeners();
    expenseCagegoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteItem(String id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await _categoryDB.delete(id);
  }
}
