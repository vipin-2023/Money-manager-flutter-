import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/models/Category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text("Add Category"),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _nameEditingController,
            decoration: const InputDecoration(
              hintText: "Category name",
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: const [
              RadioButton(title: "Income", type: CategoryType.income),
              RadioButton(title: "Expense", type: CategoryType.expense),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text;
                if (_name.isEmpty) {
                  return;
                }
                final _category = CategoryModel(
                    type: selectedCategoryNotifier.value,
                    name: _nameEditingController.text,
                    id: DateTime.now().millisecondsSinceEpoch.toString());
                //add function here...s
                CategoryDB().insertCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text("OK")),
          const SizedBox(
            height: 5,
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                });
          },
        ),
        Text(title)
      ],
    );
  }
}
