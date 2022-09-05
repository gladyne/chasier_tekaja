import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final nipdController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "NIPD",
              ),
              controller: nipdController,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Amount",
              ),
              controller: amountController,
            ),
            TextButton(
              onPressed: () {
                print(nipdController.text);
                print(amountController.text);
              },
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
