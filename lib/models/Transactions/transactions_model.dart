import 'dart:ffi';

import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/Category/category_model.dart';

part 'transactions_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String purpose;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final CategoryType type;
  @HiveField(5)
  final CategoryModel category;
  @HiveField(6)
  final bool isDeleted;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.purpose,
    required this.date,
    required this.type,
    required this.category,
    this.isDeleted = false,
  });
}
