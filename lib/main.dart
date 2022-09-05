import 'package:cashier_tekaja/widgets/history_list.dart';
import 'package:cashier_tekaja/widgets/new_transaction.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      title: "Chashier Tekaja",
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  void _startNewTransaction() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Chasier APP"),
      ),
      body: Column(
        children: [
          HistoryList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startNewTransaction();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
