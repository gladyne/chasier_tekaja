import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'current_formatter.dart';

class HistoryPage extends StatelessWidget {
  Future<List<dynamic>> _getRecentHistory() async {
    final url = Uri.parse("https://dompetsantri.herokuapp.com/api/transaction");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final transactionData = json.decode(response.body);
      return transactionData;
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _getRecentHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      if (data[index]['isCO']) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.only(
                              left: mediaQueryWidth * 0.05,
                              right: mediaQueryWidth * 0.05,
                              bottom: mediaQueryHeight * 0.01),
                          child: ListTile(
                            title: Text("${data[index]['custName']}"),
                            subtitle: Text(
                              DateFormat().format(
                                  DateTime.parse(data[index]['createdAt'])),
                            ),
                            trailing: Text(
                              "- ${CurrencyFormat.convertToIdr(data[index]['total'], 0)}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.only(
                              left: mediaQueryWidth * 0.05,
                              right: mediaQueryWidth * 0.05,
                              bottom: mediaQueryHeight * 0.01),
                          child: ListTile(
                            title: Text("${data[index]['custName']}"),
                            subtitle: Text(
                              DateFormat().format(
                                  DateTime.parse(data[index]['createdAt'])),
                            ),
                            trailing: Text(
                              "+ ${CurrencyFormat.convertToIdr(data[index]['total'], 0)}",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Text("${snapshot.error}");
                }
              }
            },
          ),
        )
      ],
    );
  }
}
