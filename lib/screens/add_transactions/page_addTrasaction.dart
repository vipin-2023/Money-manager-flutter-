import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transactions_db/transactions_db.dart';

import 'package:money_manager/models/Category/category_model.dart';
import 'package:money_manager/models/Transactions/transactions_model.dart';

class ScreenAddTransactions extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransactions({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionssState();
}

class _ScreenAddTransactionssState extends State<ScreenAddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  final _nameEditingController = TextEditingController();
  final _amonutEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // if (_amonutEditingController.text == null) {
    //   _amonutEditingController.text = "";
    // }
    // if (_nameEditingController.text == null) {
    //   _nameEditingController.text = "";
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction "),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _amonutEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Amount',
                    hintStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Purpose',
                    hintStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      //date
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : _selectedDate.toString(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.income;
                                _categoryId = null;
                              });
                            }),
                        const Text("Income"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.expense;
                                _categoryId = null;
                              });
                            }),
                        const Text("Expense"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  hint: const Text("Select Category"),
                  value: _categoryId,
                  items: (_selectedCategoryType == CategoryType.income
                          ? CategoryDB.instance.incomeCagegoryListNotifier
                          : CategoryDB.instance.expenseCagegoryListNotifier)
                      .value
                      .map(
                    (e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                        onTap: () {
                          _selectedCategoryModel = e;
                        },
                      );
                    },
                  ).toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      _categoryId = selectedValue;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final amount =
                          double.tryParse(_amonutEditingController.text);
                      if (amount == null) {
                        return;
                      }
                      if (_selectedCategoryModel == null) {
                        return;
                      }
                      if (_selectedCategoryType == null) {
                        return;
                      }
                      if (_selectedDate == null) {
                        return;
                      }
                      if (_categoryId == null) {
                        return;
                      }

                      final modelDB = TransactionModel(
                          amount: amount,
                          category: _selectedCategoryModel!,
                          type: _selectedCategoryType!,
                          date: _selectedDate!,
                          purpose: _nameEditingController.text,
                          id: DateTime.now().millisecondsSinceEpoch.toString());
                      TransactionDb().insertTransactions(modelDB);

                      Navigator.of(context).pop();
                      TransactionDb().refreshTransactionUi();
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
