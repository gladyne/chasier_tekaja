import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryList extends StatelessWidget {
  Future<List<dynamic>> _fetcTransaction() async {
    final response = await http
        .get(Uri.parse('https://dompetsantri.herokuapp.com/api/transaction'));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('testing');
    return FutureBuilder(
      future: _fetcTransaction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data as List<dynamic>;
            return Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: Text('Rp.${data[index]['total']}'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data[index]['_id']),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat().format(
                                  DateTime.parse(data[index]['createdAt'])),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Text("${snapshot.error}");
          }
        }
      },
    );
  }
}
