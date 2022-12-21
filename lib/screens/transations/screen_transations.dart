import 'package:flutter/material.dart';
import 'package:money_manager/db/transactions_db/transactions_db.dart';
import 'package:money_manager/models/Category/category_model.dart';
import 'package:money_manager/models/Transactions/transactions_model.dart';
import 'package:intl/intl.dart';

class ScreenTransations extends StatelessWidget {
  const ScreenTransations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDb().refreshTransactionUi();
    return ValueListenableBuilder<List<TransactionModel>>(
      valueListenable: TransactionDb().transactionsListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return newList.isNotEmpty
            ? ListView.separated(
                itemBuilder: (BuildContext ctx, int index) {
                  final transaction = newList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        subtitle: Text(transaction.category.name),
                        // subtitle: Text(transaction.id),
                        leading: CircleAvatar(
                          radius: 25,
                          child: Text(
                            parseDate(transaction.date),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor:
                              transaction.type == CategoryType.income
                                  ? const Color.fromARGB(255, 0, 118, 4)
                                  : const Color.fromARGB(255, 154, 10, 0),
                        ),
                        title: Text('${transaction.amount}'),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Delete",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    content: const Text(
                                      "Are you sure want to Delete ?",
                                      style: TextStyle(fontSize: 21),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            TransactionDb()
                                                .deleteItem(transaction.id);
                                            Navigator.of(context).pop();
                                            TransactionDb()
                                                .refreshTransactionUi();
                                          },
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "NO",
                                            style: TextStyle(fontSize: 18),
                                          ))
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext ctx, int index) {
                  return const Divider(
                    height: 2,
                  );
                },
                itemCount: newList.length,
              )
            : const Center(
                child: Text(
                  "Add Transactions",
                  style: TextStyle(color: Colors.grey, fontSize: 26),
                ),
              );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(" ");
    return '${_splitDate.last}\n${_splitDate.first}';
  }
}
