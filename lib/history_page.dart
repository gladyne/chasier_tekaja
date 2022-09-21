import 'dart:convert';

import 'package:cashier_tekaja/filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'current_formatter.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<dynamic>> getDataHistory;

  late List<dynamic> data;
  late List<dynamic> dataToUser;

  Future<List<dynamic>> getRecentHistoryFromApi() async {
    final url = Uri.parse("https://dompetsantri.herokuapp.com/api/transaction");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      dataToUser = data;
      return data;
    } else {
      throw Exception();
    }
  }

  void _searchHistory(String query) {
    print('lagi search');
    final sugestion = data.where((history) {
      final name = history['custName'].toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input);
    }).toList();

    setState(() {
      dataToUser = sugestion;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataHistory = getRecentHistoryFromApi();
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
              Text(
                'History',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: TextField(
                  onChanged: _searchHistory,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print(data);
                },
                icon: Icon(Icons.filter),
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getDataHistory,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataToUser.length,
                    itemBuilder: (context, index) {
                      if (dataToUser[index]['isCO']) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.only(
                              left: mediaQueryWidth * 0.05,
                              right: mediaQueryWidth * 0.05,
                              bottom: mediaQueryHeight * 0.01),
                          child: ListTile(
                            title: Text("${dataToUser[index]['custName']}"),
                            subtitle: Text(
                              DateFormat().format(DateTime.parse(
                                  dataToUser[index]['createdAt'])),
                            ),
                            trailing: Text(
                              "- ${CurrencyFormat.convertToIdr(dataToUser[index]['total'], 0)}",
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
                              DateFormat().format(DateTime.parse(
                                  dataToUser[index]['createdAt'])),
                            ),
                            trailing: Text(
                              "+ ${CurrencyFormat.convertToIdr(dataToUser[index]['total'], 0)}",
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
