import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/Transactions/transactions_model.dart';

const trasactionDbName = "transaction-db";

abstract class TransactionsDbFunctions {
  Future<void> insertTransactions(TransactionModel value);
  Future<List<TransactionModel>> getTrasactions();
  Future<void> deleteItem(String id);
  Future<void> refreshTransactionUi();
}

class TransactionDb implements TransactionsDbFunctions {
  ValueNotifier<List<TransactionModel>> transactionsListNotifier =
      ValueNotifier([]);
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb() {
    return instance;
  }
  @override
  Future<void> insertTransactions(TransactionModel value) async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(trasactionDbName);
    await transactionDb.put(value.id, value);
  }

  @override
  Future<List<TransactionModel>> getTrasactions() async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(trasactionDbName);
    return transactionDb.values.toList();
  }

  @override
  Future<void> deleteItem(String id) async {
    final transactionDb =
        await Hive.openBox<TransactionModel>(trasactionDbName);
    transactionDb.delete(id);
  }

  @override
  Future<void> refreshTransactionUi() async {
    final allTransactions = await getTrasactions();
    transactionsListNotifier.value.clear();

    // allTransactions.reversed;
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    transactionsListNotifier.value.addAll(allTransactions);

    transactionsListNotifier.notifyListeners();
  }
}
