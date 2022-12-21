import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/models/Category/category_model.dart';
import 'package:money_manager/screens/home/widgets/category_delete_popup.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCagegoryListNotifier,
        builder: (BuildContext ctx, List<CategoryModel> newItem, Widget? _) {
          return newItem.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (ctx, index) {
                    final category = newItem[index];
                    return Card(
                      child: ListTile(
                        minVerticalPadding: 20,
                        title: Text(
                          category.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showCategoryDeltePopup(ctx, category.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: newItem.length)
              : const Center(
                  child: Text(
                  "Add Expense Category",
                  style: TextStyle(color: Colors.grey, fontSize: 26),
                ));
        });
  }
}
