import 'dart:convert';

import 'package:cashier_tekaja/widgets/history_list.dart';
import 'package:cashier_tekaja/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        Uri.parse('https://dompetsantri.herokuapp.com/api/transaction'),
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
    final mediaQueryHight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: mediaQueryHight * 0.13,
            width: mediaQueryWidth * 0.6,
            margin: EdgeInsets.only(left: mediaQueryWidth * 0.05),
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
            decoration: const BoxDecoration(color: Colors.blue),
            child: LayoutBuilder(builder: (context, constraint) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: constraint.maxHeight * 0.15,
                    child: FittedBox(
                      child: Text(
                        'Basith',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraint.maxHeight * 0.1,
                  ),
                  Container(
                    height: constraint.maxHeight * 0.1,
                    child: FittedBox(
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
                  Container(
                    height: constraint.maxHeight * 0.3,
                    child: FittedBox(
                      child: Text(
                        'Rp. 5.000.000',
                        style: TextStyle(
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
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.only(
                      left: mediaQueryWidth * 0.05,
                      right: mediaQueryWidth * 0.05,
                      bottom: mediaQueryHight * 0.01),
                  child: ListTile(
                    title: Text('Nama'),
                    subtitle: Text('tanggal'),
                    trailing: Text(
                      '- Rp. 10.000',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.payment, title: 'TopUp'),
          TabItem(icon: Icons.history, title: 'History')
        ],
        style: TabStyle.fixed,
      ),
    );
  }
}
