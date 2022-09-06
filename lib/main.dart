import 'dart:convert';

import 'package:cashier_tekaja/widgets/history_list.dart';
import 'package:cashier_tekaja/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  void _sendData(String nipd, num amount) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{"nipd": nipd, "amount": amount}));
    final result = json.decode(response.body);
    print(result);
    setState(() {});
  }

  void _startNewTransaction() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction(_sendData),
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
