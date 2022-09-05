import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryList extends StatelessWidget {
  void httRequest() async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:5000/api/transaction'));
    var hasil = json.decode(response.body);
    print(hasil[0]['custName']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Hai",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            httRequest();
          },
          child: Text('Test'),
        ),
      ],
    );
  }
}
