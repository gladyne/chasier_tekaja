import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  State<NewTransaction> createState() {
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final nipdController = TextEditingController();

  final amountController = TextEditingController();

  void _submitHandler() {
    final nipd = nipdController.text;
    final amount = num.parse(amountController.text);

    if (nipd.isEmpty || amount < 0) {
      return;
    }

    widget.addTransaction(nipd, amount);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print('newtransaction');
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
                _submitHandler();
              },
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
