import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';

Future<void> showCategoryDeltePopup(BuildContext context, String id) async {
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(17),
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Are you sure want to \ndelete ?",
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(fontSize: 25, color: Colors.blue),
                ),
                onPressed: () {
                  CategoryDB().deleteItem(id);
                  CategoryDB().refreshUi();
                  //delete function goes here..
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(fontSize: 25, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
