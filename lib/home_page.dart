import 'dart:convert';

import 'package:cashier_tekaja/cash_out.dart';
import 'package:cashier_tekaja/current_formatter.dart';
import 'package:cashier_tekaja/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:convert/convert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NfcTag? tag;
  String identifier = "";
  var data;

  void _sendData(String nipd, num amount) async {
    final response = await http.post(
        Uri.parse('https://dompetsantri.herokuapp.com/api/transaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{"nipd": nipd, "amount": amount}));
    final result = json.decode(response.body);
    print(result);
    setState(() {});
  }

  Future<List<dynamic>> _getRecentHistory() async {
    final url =
        Uri.parse("https://dompetsantri.herokuapp.com/api/transaction?limit=4");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final transactionData = json.decode(response.body);
      return transactionData;
    } else {
      throw Exception();
    }
  }

  void _startNewTransaction() {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction(_sendData),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('terdispose');
    NfcManager.instance.stopSession().catchError((_) {/* no op */});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      NfcManager.instance.stopSession();
      setState(() async {
        this.tag = tag;
        identifier = hex.encode(NfcA.from(tag)?.identifier as List<int>);
        var response = await http.get(Uri.parse(
            'https://dompetsantri.herokuapp.com/api/user/${identifier}'));
        data = json.decode(response.body) as Map<String, dynamic>;
      });
    });
    var submitTextStyle = GoogleFonts.nunito(
        fontSize: 12,
        letterSpacing: 5,
        color: Colors.white,
        fontWeight: FontWeight.w300);
    final mediaQueryHight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: mediaQueryHight * 0.13,
          width: mediaQueryWidth * 0.6,
          margin: EdgeInsets.only(
            left: mediaQueryWidth * 0.05,
            top: mediaQueryHight * 0.015,
          ),
          child: LayoutBuilder(builder: (context, constraint) {
            return const FittedBox(
              child: Text(
                'Dompet Santri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),
        Container(
          height: mediaQueryHight * 0.25,
          margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.05),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: LayoutBuilder(builder: (context, constraint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data != null)
                  Container(
                    height: constraint.maxHeight * 0.15,
                    child: FittedBox(
                      child: Text(
                        data['nama'],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (data == null)
                  Container(
                    height: constraint.maxHeight * 0.15,
                    child: const FittedBox(
                      child: Text(
                        "Nama",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: constraint.maxHeight * 0.1,
                ),
                Container(
                  height: constraint.maxHeight * 0.1,
                  child: const FittedBox(
                    child: Text(
                      'Saldo:',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraint.maxHeight * 0.1,
                ),
                if (data != null)
                  Container(
                    height: constraint.maxHeight * 0.3,
                    child: FittedBox(
                      child: Text(
                        CurrencyFormat.convertToIdr(data['saldo'], 2),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (data == null)
                  Container(
                    height: constraint.maxHeight * 0.3,
                    child: FittedBox(
                      child: Text(
                        CurrencyFormat.convertToIdr(0, 2),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
        SizedBox(
          height: mediaQueryHight * 0.015,
        ),
        if (data != null)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.05),
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CashOutPage(data['nama'], data['nipd']);
                  }));
                },
                icon: Icon(Icons.payment),
                label: Text('Withdraw')),
          ),
        Container(
          margin: EdgeInsets.only(left: mediaQueryWidth * 0.05),
          child: const FittedBox(
            child: Text(
              'Riwayat terakhir :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      if (data[index]['isCO']) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.only(
                              left: mediaQueryWidth * 0.05,
                              right: mediaQueryWidth * 0.05,
                              bottom: mediaQueryHight * 0.01),
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
                              bottom: mediaQueryHight * 0.01),
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
        ),
      ],
    );
  }
}
